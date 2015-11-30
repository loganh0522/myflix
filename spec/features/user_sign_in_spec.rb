require 'spec_helper'

feature "user signs in" do 
  scenario "with valid email and password user signs in" do
    alice = Fabricate(:user)
    sign_in(alice)
    page.should have_content alice.full_name
  end
end