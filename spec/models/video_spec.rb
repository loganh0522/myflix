require 'spec_helper'
require 'shoulda/matchers'

describe Video do 
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

  describe "search_by_title" do 
    it "should return an empty array if the title does not have a match" do 
      patriot = Video.create(title: "Patriot", description: "Movie about the American Revolution")
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever")
      expect(Video.search_by_title("Thor")).to eq([])
    end 

    it "should return an array with one video for an exact match" do
      patriot = Video.create(title: "Patriot", description: "Movie about the American Revolution")
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever")
      expect(Video.search_by_title("Patriot")).to eq([patriot])
    end

    it "should return an array of videos for a partial match" do
      patriot = Video.create(title: "Patriot", description: "Movie about the American Revolution")
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever")
      expect(Video.search_by_title("Star")).to eq([star_wars])
    end

    it "should return an array of videos order by created_at" do 
      starship = Video.create(title: "Starship", description: "Movie about the American Revolution", created_at: 1.day.ago)
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever")
      expect(Video.search_by_title("Star")).to eq([star_wars, starship])
    end

    it "should return an empty array if the search term is blank" do
      starship = Video.create(title: "Starship", description: "Movie about the American Revolution", created_at: 1.day.ago)
      star_wars = Video.create(title: "Star Wars", description: "Best Series Ever")
      expect(Video.search_by_title("")).to eq([])
    end

  end
end
