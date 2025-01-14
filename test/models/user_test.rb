require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @admin_user = users(:f_admin)
    @second_admin = users(:f_admin2)
    @user = users(:f_user)
  end

  test "should not save user without email" do
    user = User.new
    user.password = @user.password
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user without password" do
    user = User.new
    user.email = @user.email
    assert_not user.save, "Saved the user without a password"
  end

  test "should save user with username, email and password" do
    user = User.new(email: @user.email, password: @user.encrypted_password)
    unless user.save
      puts user.errors.full_messages
    end
    assert user.save, "Could not save the user with username, email, and password"
  end

  test "should not change role of last admin" do
    @second_admin.destroy
    @admin_user.role = "user"
    assert_not @admin_user.save, "Changed the role of the last admin"
  end

  test "should not delete last admin" do
    @second_admin.destroy
    @admin_user.destroy
    assert_not @admin_user.destroy, "Deleted the last admin"
  end
end
