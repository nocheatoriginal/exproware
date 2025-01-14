require "test_helper"

class ExpertTest < ActiveSupport::TestCase
  setup do
    @expert = experts(:alice_wonderland)
  end

  test "should create expert" do
    Expert.find_by(email: @expert.email)&.destroy

    expert = Expert.new(first_name: @expert.first_name, last_name: @expert.last_name, academic_title: @expert.academic_title, salary: @expert.salary, travel_willingness: @expert.travel_willingness, categories: @expert.categories, profile_image: @expert.profile_image, biography: @expert.biography, email: @expert.email) 
    assert expert.save, "Failed to save the expert"
  end

  test "should read expert information" do
    expert = experts(:emilia_clarke)
    assert_equal experts(:emilia_clarke).first_name, expert.first_name
    assert_equal experts(:emilia_clarke).email, expert.email
  end

  test "should destroy expert" do
    expert = experts(:jason_bourne)
    assert expert.destroy, "Failed to destroy the expert"
  end

  test "existing expert can be destroyed and user stays active" do
    assert_no_difference('User.count') do
      assert experts(:alice_wonderland).destroy
    end
  end

  test "user ist not initialized after expert is destroyed" do
    assert users(:f_user).initialized
    assert experts(:alice_wonderland).destroy
    assert users(:f_user).reload
    assert_not users(:f_user).initialized
  end
end
