# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include HandleError
  before_action :authenticate_user!, except: :raise_not_found
end
