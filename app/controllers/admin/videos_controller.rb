class Admin::VideosController < ApplicationController 
  before_filter :require_user
  before_filter :require_admin

  def new 
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)

    if @video.save
      flash[:success] = "You have successfully added the video #{@video.title}"
      redirect_to new_admin_video_path
    else 
      render :new
      flash[:error] = "Your video was not saved"
    end
    
  end

  private 

  def require_admin
    if !current_user.admin? 
      flash[:error] = "You can not access that"
      redirect_to home_path unless current_user.admin? 
    end
  end

  def video_params
    params.require(:video).permit(:category, :description, :title)
  end
end