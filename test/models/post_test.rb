require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "fixture data" do
    posts(:one)
    assert_equal "MyString", posts(:one).title
  end

  # Delete later ...
end
