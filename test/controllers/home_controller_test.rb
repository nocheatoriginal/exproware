require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Sign in as Admin to access the homepage
    sign_in users(:f_admin)
  end

  test "should get index if signed in" do
    get home_index_url
    assert_response :success
  end
end
