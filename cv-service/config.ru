require 'sinatra'
require "sinatra/reloader" if development?
require 'rack/cache'
require 'redis-rack-cache'

class Service < Sinatra::Base
  get '/' do
    erb :homepage, locals: with_k8s_locals({ title: "Homepage" })
  end

  get '/cv' do
    cache_control :public, max_age: 1800
    erb :cv, locals: with_k8s_locals({ title: "CV" })
  end

  private

  def with_k8s_locals(locals)
    locals.merge!(k8s_pod_info)
  end

  def k8s_pod_info
    {
      pod_ip: ENV['POD_IP'] || 'UNAVAILABLE',
      pod_name: ENV['POD_NAME'] || 'UNAVAILABLE'
    }
  end
end

if production?
  use Rack::Cache, verbose: true, metastore: 'redis://redis-cache-service:6379/0', entitystore: 'redis://redis-cache-service:6379/1'
end

run Service
