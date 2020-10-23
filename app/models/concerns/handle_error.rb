module HandleError
  extend ActiveSupport::Concern

  SLACK_IGNORE_ERRORS = [ActionController::InvalidAuthenticityToken].freeze

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from Exception, with: :render_server_error
    rescue_from ActionController::RoutingError, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotSaved, with: :render_unprocessable_entity

    def raise_not_found
      raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
    end

    protected

    def render_not_found
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      end
    end

    def render_server_error exception
      respond_to do |format|
        format.html do
          if SLACK_IGNORE_ERRORS.exclude? exception.class
            Slack::ErrorService.new(exception, :controller, request).perform
          end
          render file: "#{Rails.root}/public/500", layout: false, status: :internal_server_error
        end
      end
    end

    def render_unprocessable_entity exception
      respond_to do |format|
        format.html do
          Slack::ErrorService.new(exception, :controller, request).perform
          render file: "#{Rails.root}/public/422", layout: false, status: :unprocessable_entity
        end
      end
    end
  end unless Rails.env.development?
end
