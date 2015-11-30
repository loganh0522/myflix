class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  def video_title
    video.title
  end

  def rating
    review
    review.rating if review
  end

  def rating=(new_rating)
    review 
    if review 
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    video.category.name
  end

  def category 
    video.category
  end

  private

  def review 
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
  
end
