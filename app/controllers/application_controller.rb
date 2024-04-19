class ApplicationController < ActionController::API
  def datetime_with_zone(str)
    return nil if str.nil?
    Time.zone.parse(str)
  end
  
  private

  def current_user
    @current_user ||= User.find(request.env["current_user_id"])
  end
end
