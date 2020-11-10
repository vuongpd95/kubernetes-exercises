require './service.rb'

if production?
  use Rack::Cache, verbose: true, metastore: ENV['REDIS_CACHE_METASTORE'], entitystore: ENV['REDIS_CACHE_ENTITYSTORE']
end

run Service
