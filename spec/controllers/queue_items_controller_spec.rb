require 'spec_helper'

describe QueueItemsController do 
  describe "GET index" do 
    it "set @queue_items to the queue items of logged in user" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index 
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    
    it_behaves_like "requires sign in" do 
      let(:action) {get :index}
    end   
  end

  describe "POST create" do 
    it "redirects to the queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do 
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item is associated with the video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the signed in user" do   
      alice = Fabricate(:user)
      set_current_user(alice)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(alice)
    end

    it "puts the video as the last one in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: alice)
      south_park = Fabricate(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: alice.id).first
      expect(south_park_queue_item.position).to eq(2)
    end

    it "does not add the video to the queue, if the video is in the queue" do
      alice = Fabricate(:user)
      set_current_user(alice)
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: alice)
      post :create, video_id: monk.id   
      expect(alice.queue_items.count).to eq(1)
    end

    it_behaves_like "requires sign in" do 
      let(:action) {post :create, video_id: 3}
    end 
  end

  describe "DELETE destroy" do 
    it "should redirect to the queue" do 
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalize the queue item" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1= Fabricate(:queue_item, user: alice, position: 1)
      queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if current user own queue_item" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      set_current_user(alice)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    
    it_behaves_like "requires sign in" do 
      let(:action) {delete :destroy, id: 3}
    end 

  end

  describe "POST update queue" do
    context "with valid inputs" do 
      it "redirects to the my_queue page" do 
        alice = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1= Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]

        expect(response).to redirect_to my_queue_path
      end

      it "reorders the items in the queue" do 
        alice = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1= Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]

        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers of queue" do 
        alice = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1= Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)

        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]

        expect(alice.queue_items.map(&:position)).to eq([1, 2])
        # expect(queue_item1.reload.position).to eq(2)
        # expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with invalid inputs" do
      it "redirects to the my queue page" do 
        alice = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1= Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]

        expect(response).to redirect_to my_queue_path
      end

      it "set the flash error message" do 
        alice = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1= Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.3}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do 
        alice = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.1}, {id: queue_item2.id, position: 2.1}]

        expect(queue_item1.reload.position).to eq(1)
      end
    end
    context "with queue items that do not belong to current_user" do
      it "does not change the queue items" do 
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        set_current_user(alice) 
        queue_item1= Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]

        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do 
      it "should redirect user to the sign in path" do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 1, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end 
  end
end
