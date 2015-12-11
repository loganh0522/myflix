class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  def new
    redirect_to home_path if current_user
    @user = User.new
  end

  def create 
    @user = User.create(user_params)
    if @user.save 
      handle_invitation
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      Stripe::Charge.create(
        :amount => 999,
        :currency => "cad",
        :card => params[:stripeToken],
        :description => "Sign Up"
      )
      AppMailer.delay.send_welcome_email(@user)
      redirect_to videos_path
    else 
      render :new 
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:password, :email, :full_name)
  end

  def handle_invitation
   if params[:invitation_token].present? 
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end