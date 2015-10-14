require 'spec_helper'

describe VideosController do 
  describe "GET show" do
    it "sets @video" do 
      video = Fabricate(:video)
      get :show, id: video.id 
      expect(assigns(:video).to eq(video))
    end
    it "renders the show template" do
    end
  end
end