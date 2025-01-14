require "application_system_test_case"

class ExpertsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:f_admin)
    @expert = experts(:one)
  end

  test "visiting the index" do
    visit experts_url
    assert_selector "h1", text: "Experts"
  end

  test "should create expert" do
    visit experts_url
    click_on "New expert"

    fill_in "Academic title", with: @expert.academic_title
    fill_in "Biography", with: @expert.biography
    fill_in "Categories", with: @expert.categories
    fill_in "Email", with: @expert.email
    fill_in "First name", with: @expert.first_name
    fill_in "Last name", with: @expert.last_name
    fill_in "Profile image", with: @expert.profile_image
    fill_in "Salary", with: @expert.salary
    fill_in "Travel willingness", with: @expert.travel_willingness
    click_on "Create Expert"

    assert_text "Expert was successfully created"
    click_on "Back"
  end

  test "should update Expert" do
    visit expert_url(@expert)
    click_on "Edit this expert", match: :first

    fill_in "Academic title", with: @expert.academic_title
    fill_in "Biography", with: @expert.biography
    fill_in "Categories", with: @expert.categories
    fill_in "Email", with: @expert.email
    fill_in "First name", with: @expert.first_name
    fill_in "Last name", with: @expert.last_name
    fill_in "Profile image", with: @expert.profile_image
    fill_in "Salary", with: @expert.salary
    fill_in "Travel willingness", with: @expert.travel_willingness
    click_on "Update Expert"

    assert_text "Expert was successfully updated"
    click_on "Back"
  end

  test "should destroy Expert" do
    visit expert_url(@expert)
    click_on "Destroy this expert", match: :first

    assert_text "Expert was successfully destroyed"
  end
end
