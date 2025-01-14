class AddExpertProfileInitializedToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :initialized, :boolean, default: false
  end
end
