require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin_user = users(:f_admin)     # Admin-Fixture
    @second_admin = users(:f_admin2)  # Zweiter Admin-Fixture
    @regular_user = users(:f_user)    # Normale Benutzer-Fixture
  end

  test 'should redirect regular user from admin index' do
    sign_in @regular_user
    get admin_users_path
    assert_redirected_to root_url
  end

  test 'should redirect non-logged-in user from admin index' do
    get admin_users_path
    assert_redirected_to new_user_session_url  # Nicht authentifizierte Nutzer zur Login-Seite
  end

  test 'should redirect regular user from edit' do
    sign_in @regular_user
    get edit_admin_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test 'should update user role for admin' do
    sign_in @admin_user
    patch update_role_admin_user_path(@second_admin), params: { user: { role: @second_admin.role } }
    assert_equal 'admin', @second_admin.reload.role
  end

  test 'should not update user role for admin if last admin' do
    sign_in @admin_user
    sign_out @second_admin
    patch update_role_admin_user_path(@admin_user), params: { user: { role: @regular_user.role } }
    assert_equal 'admin', @admin_user.reload.role
  end

  test 'should not delete last admin' do
    sign_in @admin_user
    sign_out @second_admin
    delete admin_destroy_user_path(@admin_user)
    assert_equal 'admin', @admin_user.reload.role
  end
end
