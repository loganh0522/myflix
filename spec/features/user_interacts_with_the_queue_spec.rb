require 'spec_helper'

feature "User interacts with the queue" do 
  scenario "user adds and reorders videos in the queue" do
    comedies = Fabricate(:category, name: "comedies")
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "Monk", category: comedies)
    family_guy = Fabricate(:video, title: "Family Guy", category: comedies)
    
    
    sign_in
    find("a[href= '/videos/#{monk.id}']").click 
    page.should have_content(monk.title)

    click_link "+ My Queue"
    page.should have_content(monk.title)

    visit video_path(monk)
    page.should_not have_content "+ My Queue"

    visit home_path 
    find("a[href= '/videos/#{south_park.id}']").click 
    click_link "+ My Queue"
    visit home_path
    find("a[href= '/videos/#{family_guy.id}']").click 
    click_link "+ My Queue"

    # within(:xpath, "//tr[contains(.,'#{monk.title}')]") do 
    #   fill_in "queue_items[][position]", with: 2
    # end
    
    find("input[data-video-id='#{monk.id}']").set(3)
    find("input[data-video-id='#{family_guy.id}']").set(2)
    find("input[data-video-id='#{south_park.id}']").set(1)
    # fill_in "video_#{monk.id}", with: 3
    # fill_in "video_#{south_park.id}", with: 1   fill in only works with Id, name or labels
    # fill_in "video_#{fmaily_guy.id}", with: 2

    click_button "Update Instant Queue"

    expect(find("input[data-video-id='#{south_park.id}']").value).to eq("1")
    expect(find("input[data-video-id='#{family_guy.id}']").value).to eq("2")
    expect(find("input[data-video-id='#{monk.id}']").value).to eq("3")

    clear_email
  end
end