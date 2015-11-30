class ForgotPasswordsController < ApplicationController

  def create 
    user = User.where(email: params[:email]).first
    if user 
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Email cannot be blank" : "This email does not exist"
      redirect_to forgot_password_path
    end
  end

  def confirm 

  end
end 