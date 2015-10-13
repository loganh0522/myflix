class UsersController < ApplicationController
  
  def new
    redirect_to home_path if current_user
    @user = User.new
  end

  def create 
    @user = User.create(user_params)

    if @user.save 
      flash[:notice] = "Thanks for registering with MyFlix"
      redirect_to videos_path
    else 
      render :new 
    end
  end

  private 

  def user_params 
    params.require(:user).permit(:password, :email, :full_name)
  end

end