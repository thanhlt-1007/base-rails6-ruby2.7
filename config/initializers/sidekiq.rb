Sidekiq::Extensions.enable_delay!
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379" }
  config.error_handlers << Proc.new { |ex, ctx_hash| Slack::SidekiqError.new(ex, ctx_hash[:job]["jid"]).perform }
  config.death_handlers << ->(job, ex) do
    puts "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379" }
end
