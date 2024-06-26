class Api::V1::ValidationCodesController < ApplicationController
  def create
    if ValidationCode.exists?(email: params[:email], kind:'sign_in',created_at: 1.minute.ago..Time.now)
      render status: :too_many_requests
      return
    end
    validation_code = ValidationCode.new email: params[:email], kind: 'sign_in'
    if validation_code.save
      render status: 200
    else
      render_resource validation_code
    end
  end
end
