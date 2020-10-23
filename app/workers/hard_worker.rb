class HardWorker
  include Sidekiq::Worker

  sidekiq_options queue: :say_hello, retry: false

  def perform
    logger.info "Hello world. Now is #{Time.zone.now}"
  end
end
