class Slack::SidekiqError
  def initialize exception, sidekiq_job_id
    @exception = exception
    @sidekiq_job_id = sidekiq_job_id
  end

  def perform
    Slack::ErrorService.new(exception, :service).perform
  end

  private

  attr_reader :exception, :sidekiq_job_id
end
