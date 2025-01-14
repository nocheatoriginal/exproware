class AddExpertToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :expert, foreign_key: true
  end
end
