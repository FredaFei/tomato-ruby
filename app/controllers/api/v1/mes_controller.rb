class Api::V1::MesController < ApplicationController
  def show
    user = current_user
    return head :not_found if user.nil?
    render json: { resource: user }
  end
end
