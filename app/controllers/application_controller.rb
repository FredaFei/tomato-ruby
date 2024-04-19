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

  def render_resource(resource, status: :ok)
    return head 404 if resource.nil?
    if resource.errors.empty?
      render json: { resource: resource }, status: status
    else
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end
  
  def render_resources(resources, pager: nil)
    json = { resources: resources }
    json[:pager] = pager if pager
    render json: json
  end

  def render_not_found
    render status: :not_found
  end

  def datetime_with_zone(str)
    return nil if str.nil?
    Time.zone.parse(str)
  end

  private

  def current_user
    @current_user ||= User.find(request.env["current_user_id"])
  end

  def authorize_resource_access
    resource = controller_name.classify.constantize.find(params[:id])
    return head :forbidden unless resource.user_id == current_user.id
  end
end
