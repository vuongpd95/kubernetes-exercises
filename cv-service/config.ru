require 'sinatra'
require "sinatra/reloader" if development?
require 'net/http'
require 'json'

class Service < Sinatra::Base
  get '/' do
    erb :homepage, locals: with_k8s_locals({ title: "Homepage" })
  end
  
  get '/cv' do
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

run Service
