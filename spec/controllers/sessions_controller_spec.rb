require 'spec_helper'

describe SessionsController do 
  describe "GET new" do  
    it "renders the new template for unauthenticated user" do 
      get :new
      expect(response).to render_template :new
    end
    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do 
      before do 
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password
      end

      it "puts signed in user into the session" do 
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password  
        expect(session[:user_id]).to eq(alice.id)
      end

      it "redirects the user to the home path" do
        expect(response).to redirect_to home_path
      end

      it "sets the notice for logging in" do 
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invaild credentials" do
      before do 
        alice = Fabricate(:user)
        post :create, email: alice.email, password: alice.password + 'aasdasd'
      end
      it "does not put the signed in user in the session" do  
        expect(session[:user_id]).to be_nil
      end
     
      it "renders the sign in page" do 
        expect(response).to redirect_to sign_in_path
      end

      it "sets the error message" do 
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do 
    before do
      session[:user_id] = Fabricate(:user).id 
      get :destroy 
    end
    it "clears the session for the user" do 
      expect(session[:user_id]).to be_nil
    end 
   
    it "redirects the user to the root path" do 
      expect(response).to redirect_to root_path
    end 
    
    it "sets the notice for logging out" do 
      expect(flash[:notice]).not_to be_blank
    end 
  end
end