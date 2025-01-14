require "test_helper"

class ExpertsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Sign in as Admin to access the experts
    sign_in users(:f_admin)
    @john_doe = experts(:john_doe)
  end

  test "should get index" do
    get experts_url
    assert_response :success
  end

  test "should get new" do
    get new_expert_url
    assert_response :success
  end

  test "should create expert" do
    Expert.find_by(email: @john_doe.email)&.destroy

    assert_difference("Expert.count") do
      post experts_url, params: { expert: { academic_title: @john_doe.academic_title, biography: @john_doe.biography, categories: @john_doe.categories, email: @john_doe.email, first_name: @john_doe.first_name, last_name: @john_doe.last_name, profile_image: @john_doe.profile_image, salary: @john_doe.salary, travel_willingness: @john_doe.travel_willingness } }
    end

    assert_redirected_to expert_url(Expert.last)
  end

  test "should fail to create expert" do
    assert_no_difference("Expert.count") do
      post experts_url, params: { expert: { academic_title: @john_doe.academic_title, biography: @john_doe.biography, categories: @john_doe.categories, email: @john_doe.email, first_name: @john_doe.first_name, last_name: @john_doe.last_name, profile_image: @john_doe.profile_image, salary: @john_doe.salary, travel_willingness: nil } }
    end

    assert_response :unprocessable_entity
  end

  test "should show expert" do
    get expert_url(@john_doe)
    assert_response :success
  end

  test "should get edit" do
    get edit_expert_url(@john_doe)
    assert_response :success
  end

  test "should update expert" do
    patch expert_url(@john_doe), params: { expert: { academic_title: @john_doe.academic_title, biography: @john_doe.biography, categories: @john_doe.categories, email: @john_doe.email, first_name: @john_doe.first_name, last_name: @john_doe.last_name, profile_image: @john_doe.profile_image, salary: @john_doe.salary, travel_willingness: @john_doe.travel_willingness } }
    assert_redirected_to expert_url(@john_doe)
  end

  test "should destroy expert" do
    assert_difference("Expert.count", -1) do
      delete expert_url(@john_doe)
    end

    assert_redirected_to experts_url
  end
end
