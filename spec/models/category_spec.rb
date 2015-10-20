require 'spec_helper'

describe Category do 
  it { should have_many(:videos)}
  it { should validate_presence_of(:name) }

  describe "show_recent_videos" do 
    it "Returns all videos in reverse order by created_at" do
      action = Category.create(name: "action")
      patriot = Video.create(title: "Patriot", description: "Movie about the American Revolution", category: action, created_at: 1.day.ago)
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever", category: action)
      expect(action.show_recent_videos).to eq([star_wars, patriot])
    end 

    it "Returns all videos if less than 6 videos" do
      action = Category.create(name: "action")
      patriot = Video.create(title: "Patriot", description: "Movie about the American Revolution", category: action, created_at: 1.day.ago)
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever", category: action)
      expect(action.show_recent_videos.count).to eq(2)
    end

    it "Returns only the first 6 videos in a category if more than 6" do 
      action = Category.create(name: "action")
      7.times {Video.create(title: "Patriot", description: "Movie about the American Revolution", category: action, created_at: 1.day.ago)}
      expect(action.show_recent_videos.count).to eq(6)
    end 

    it "Returns the most recent videos created in the category if more than 6" do
      action = Category.create(name: "action")
      7.times {Video.create(title: "Patriot", description: "Movie about the American Revolution", category: action)}
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever", category: action, created_at: 1.day.ago)
      expect(action.show_recent_videos).not_to include(star_wars)
    end

    it "Returns an empty array if there are no videos in the category" do 
      action = Category.create(name: "action")
      expect(action.show_recent_videos).to eq([])
    end

  end
end