class AddEmailToOneTimeLinks < ActiveRecord::Migration[7.2]
  def change
    add_column :one_time_links, :email, :string
  end
end
