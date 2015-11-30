require 'spec_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) } 
  it { should validate_uniqueness_of(:email) } 
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC")}
 
  it "generates a random token when a user is created" do 
    alice = Fabricate(:user)
    expect(alice.token).to be_present
  end
  
  describe "#video_queued?" do 
    it "returns true when the video is in the user queue" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.video_queued?(video).should be_truthy
    end
    it "returns false when the video is NOT is user queue" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      user.video_queued?(video).should be_falsey
    end
  end

  describe "#follows?" do 
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: alice, leader: bob)
      expect(alice.follows?bob).to be_truthy
    end

    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: bob, leader: alice)
      expect(alice.follows?bob).to be_falsey
    end
  end

  describe "#follow" do 
    it "follows another user" do 
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_truthy
    end
    it "does not follow oneself" do 
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_falsey
    end
  end
end
