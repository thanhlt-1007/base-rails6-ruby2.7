class Slack::ErrorService
  def initialize exception, type, request = nil
    @exception = exception
    @type = type
    @request = request
  end

  def perform
    notifier.post formats
  end

  private

  attr_reader :exception, :type, :request

  def notifier
    Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
  end

  def formats
    {
      mrkdwn: true,
      text: message
    }
  end

  def message
    type == :service ? service_message : controller_message
  end

  def service_message
    I18n.t(
      'slack.error_messages.error_detail',
      error_message: exception.message,
      error_detail: exception.backtrace[0...10].join('\n')
    )
  end

  def controller_message
    "[#{Rails.env}]#{status_messsage}#{request_message}#{environment_message}#{detail_message}"
  end

  def status_messsage
    I18n.t('slack.error_messages.error_status', error_status: exception.class)
  end

  def request_message
    I18n.t(
      'slack.error_messages.request',
      url: request.original_url,
      http_method: request.method,
      ip: request.ip,
      parameters: request.params,
      timestamp: Time.zone.now,
      server: request.env['SERVER_NAME'],
      rails_root: Rails.root,
      process: Process.pid
    )
  end

  def environment_message
    I18n.t(
      'slack.error_messages.environment',
      http_connection: request.env['HTTP_CONNECTION'],
      http_host: request.env['HTTP_HOST'],
      http_user_agent: request.env['HTTP_USER_AGENT'],
      http_x_forwarded_for: request.env['HTTP_X_FORWARDED_FOR'],
      http_x_real_ip: request.env['HTTP_X_REAL_IP'],
      path_info: request.env['PATH_INFO'],
      query_string: request.env['QUERY_STRING'],
      remote_addr: request.env['REMOTE_ADDR'],
      request_method: request.env['REQUEST_METHOD'],
      request_uri: request.env['REQUEST_URI'],
      script_name: request.env['SCRIPT_NAME'],
      server_name: request.env['SERVER_NAME'],
      server_port: request.env['SERVER_PORT'],
      server_protocol: request.env['SERVER_PROTOCOL'],
      server_software: request.env['SERVER_SOFTWARE']
    )
  end

  def detail_message
    I18n.t(
      'slack.error_messages.error_detail',
      error_message: exception.message,
      error_detail: exception.backtrace[0...10].join('\n')
    )
  end
end
