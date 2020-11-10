require 'rubygems'
require 'bundler'

Bundler.require
Dir['./models/**/*.rb'].each { |file| require file }

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
