require 'sidekiq'

redis_host = ENV['REDIS_HOST']
redis_port = ENV['REDIS_PORT']
redis_url = "redis://#{redis_host}:#{redis_port}"

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, size: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end
