require 'spec_helper'

describe UsersController do 
  describe "GET new" do  
    it "sets @user" do 
      get :new 
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create" do 
    context "with valid input" do 
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "creates the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to the sign in page" do     
        expect(response).to redirect_to videos_path
      end

      it "makes the user follow the inviter"  do 
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Dirt"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(joe.follows?(alice)).to be_truthy
      end

      it "make the inviter follow the user" do 
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Dirt"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(alice.follows?(joe)).to be_truthy
      end

      it "expires the invitation upon acceptance" do 
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joe@example.com")
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Dirt"}, invitation_token: invitation.token
        joe = User.where(email: "joe@example.com").first
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with invalid input" do
      before { post :create, user: {password: "pword", full_name: "kevin"}}
      it "does not create the user" do      
        expect(User.count).to eq(0)
      end
      it "redners the :new template" do 
        expect(response).to render_template :new
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "sends emails" do 
      before { ActionMailer::Base.deliveries.clear }
      
      it "does not send out an email with invalid inputs" do 
        post :create, user: {email: "joe@example.com"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sends out email to user with valid inputs" do 
        post :create, user: {email: "joe@example.com", full_name: "Joe Dirt", password: "password"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing users name with valid inputs" do 
        post :create, user: {email: "joe@example.com", full_name: "Joe Dirt", password: "password"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Dirt")
      end      
    end
  end

  describe "GET show" do 
    it_behaves_like "requires sign in" do 
      let(:action) {get :show, id: 3}
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end 
  end

  describe "GET new_with_invitation_token" do 
    it "renders the new view template" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets the @invitation_token" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "sets @user with reciepients email" do 
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "redirects user with expired token to expired token page" do 
      get :new_with_invitation_token, token: "12334"
      expect(response).to redirect_to expired_token_path
    end

  end
end


