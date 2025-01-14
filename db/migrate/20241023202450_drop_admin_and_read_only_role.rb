class DropAdminAndReadOnlyRole < ActiveRecord::Migration[7.2]
  def change
    drop_table :admins
    drop_table :read_onlies
  end
end
