class CreateOneTimeLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :one_time_links do |t|
      t.string :token
      t.boolean :used
      t.datetime :expires

      t.timestamps
    end
  end
end
