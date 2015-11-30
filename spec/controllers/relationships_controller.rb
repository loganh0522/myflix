require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets relationships to the current users following relationship" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricatate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationship).to eq(relationship)
    end

    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end
  end

  describe "DELETE destroy" do 
    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 4}
    end

    it "redirects to the people page " do 
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricatate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end 

    it "destroys the relationship if the current user is the follower" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricatate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end 

    it "does not destroy the relationship if the current user is not the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      charlie = Fabricate(:user)
      relationship = Fabricatate(:relationship, follower: charlie, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end 
  end
 
  describe "POST create" do 
    it_behaves_like "requires sign in" do
      let(:action) {post :create}
    end

    it "redirects to the people page" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob 
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows leader" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob 
      expect(alice.following_relationship.first.leader).to eq(bob)
    end

    it "does not create a relationship if current user already follows" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: alice, leader: bob)
      post :create, leader_id: bob 
      expect(Relationship.count).to eq(1)
    end
    
    it "does not allow one to follow themselves" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id 
      expect(Relationship.count).to eq(0)
    end
  end
end