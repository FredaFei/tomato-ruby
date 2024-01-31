class UserMailer < ApplicationMailer
  def welcome_email
    # @user = params[:user]
    # @url  = 'http://example.com/login'
    mail(to: "964959033@qq.com", subject: 'ha')
  end
end
