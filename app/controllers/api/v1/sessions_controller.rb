class Api::V1::SessionsController < ApplicationController
  def create
    session = Session.new params.permit :email, :code
    if session.valid?
      user = User.find_or_create_by email: session.email
      render json: { jwt: user.generate_jwt }
    else
      render_resource session
    end
  end
end
