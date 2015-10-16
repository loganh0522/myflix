class ReviewsController < ApplicationController  
  def create
    video = Video.find(params[:video_id])
    video.reviews.create(params[review_params])
    redirect_to video
  end 

  private 

  def review_params
    params.require(:review).permit(:content, :rating, :user_id, :video_id)
  end
end 