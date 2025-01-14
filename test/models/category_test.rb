require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "should create category" do
    category = Category.new(name: categories(:chemistry).name)
    assert category.save, "Failed to save the category"
  end

  test "should read category" do
    category = categories(:mathematics)
    assert_equal categories(:mathematics).name, category.name
  end

  test "should destroy category" do
    category = categories(:biology)
    assert category.destroy, "Failed to destroy the category"
  end

  test "should not save category without name" do
    category = Category.new()
    assert_not category.save, "Saved the category without a name"
  end
end
