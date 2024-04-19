require 'custom_error'

class ApplicationController < ActionController::API
  rescue_from CustomError::MustSignInError, with: :render_must_sign_in

  def must_sign_in
    if current_user.nil?
      raise CustomError::MustSignInError
    end
  end

  def render_must_sign_in
    render status: :unauthorized
  end

  def datetime_with_zone(str)
    return nil if str.nil?
    Time.zone.parse(str)
  end

  private

  def current_user
    @current_user ||= User.find(request.env["current_user_id"])
  end
end
