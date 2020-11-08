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
    locals.merge!(uuid_info)
  end

  def k8s_pod_info
    {
      pod_ip: ENV['POD_IP'] || 'UNAVAILABLE',
      pod_name: ENV['POD_NAME'] || 'UNAVAILABLE'
    }
  end

  def uuid_info
    addr = uuid_service_addr
    return {uuid_service_address: 'NOT CONFIGURED', uuid: 'UNAVAILABLE'} unless addr

    {
      uuid_service_address: addr,
      uuid: uuid_from_service(addr)
    }
  end

  def uuid_service_addr
    uuid_service_prefix = ENV['UUID_SERVICE_NAME']&.upcase
    uuid_service_host = ENV["#{uuid_service_prefix}_SERVICE_HOST"]
    uuid_service_port = ENV["#{uuid_service_prefix}_SERVICE_PORT"]

    return nil unless uuid_service_host && uuid_service_port

    "http://#{uuid_service_host}:#{uuid_service_port}/uuid"
  end

  def uuid_from_service(addr)
    parsed_response = JSON.parse(Net::HTTP.get(URI(addr)))
    parsed_response['uuid']
  rescue => e
    'UNAVAILABLE'
  end
end

run Service
