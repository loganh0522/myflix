require 'spec_helper'

describe PasswordResetsController do 
  describe 'GET show' do 
    it "renders show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets the token for the user " do 
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end

    it "redirects to the expired token page if the token is invaild" do 
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST create' do 
    context "with valid token" do 
      it "should redirect to the sign in page" do
        alice = Fabricate(:user, password: 'old password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(response).to redirect_to sign_in_path
      end

      it "should update the users password" do 
        alice = Fabricate(:user, password: 'old password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        alice.reload.authenticate('new password').should be_truthy
      end

      
      it "sets the flash success message" do
        alice = Fabricate(:user, password: 'old password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(flash[:success]).to be_present
      end

      it "regenerates the user token" do 
        alice = Fabricate(:user, password: 'old password')
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(alice.reload.token).not_to eq('12345')
      end
    end
    
    context "with invalid token" do 
      it "redirects to the expired token path" do 
        post :create, token: '12345', password: 'new password'
        expect(response).to redirect_to expired_token_path
      end
    end

  end
end 