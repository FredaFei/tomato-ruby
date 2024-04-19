class Api::V1::MesController < ApplicationController
  before_action :must_sign_in

  def show
    render_resource current_user
  end
end
