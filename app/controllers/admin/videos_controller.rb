class Admin::VideosController < ApplicationController 
  before_filter :require_user
  before_filter :require_admin

  def new 
    @video = Video.new
  end

  def require_admin
    if !current_user.admin? 
      flash[:error] = "You can not access that"
      redirect_to home_path unless current_user.admin? 
    end
  end
end