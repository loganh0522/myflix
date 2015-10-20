class ReviewsController < ApplicationController  
  before_filter :require_user
  def create
    @video = Video.find(params[:video_id])
    
    review = @video.reviews.build(review_params.merge!(user: current_user))
    # review.save(user: current_user) 
    # review.save( user: current_user)

    if review.save 
      redirect_to @video 
    else
      @reviews = @video.reviews.reload #reload loads from DB and only valid obkects
      render 'videos/show'
    end
  end 

  private 

  def review_params
    params.require(:review).permit(:content, :rating, :user_id, :video_id)
  end
end 