require 'spec_helper'

describe InvitationsController do 
  describe "GET new" do 
    it "sets the @invitation to a new invitation" do 
      set_current_user
      get :new 
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation 
    end

    it_behaves_like "requires sign in" do 
      let(:action) {get :new}
    end
  end

  describe "POST create" do 
    it_behaves_like "requires sign in" do 
      let(:action) {post :create}
    end

    context "with valid inputs" do
      it "redirects to the invitation new page" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt", recipient_email: "joe@example.com", message: "Welcome"}
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt", recipient_email: "joe@example.com", message: "Welcome"}
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt", recipient_email: "joe@example.com", message: "Welcome"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sets the flash success message" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt", recipient_email: "joe@example.com", message: "Welcome"}
        expect(flash[:success]).to be_present
      end
    end


    context "with invalid inputs" do 
      before { ActionMailer::Base.deliveries.clear }
      it "renders the new template" do
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt" }
        expect(response).to render_template :new
      end

      it "sets the @invitation" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt" }
        expect(:invitation).to be_present
      end

      it "does not create an invitation" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out an email" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it "sets the flash error message" do 
        set_current_user
        post :create, invitation: {recipient_name: "Joe Dirt" }
        expect(flash[:error]).to be_present
      end
    end
  end 
end