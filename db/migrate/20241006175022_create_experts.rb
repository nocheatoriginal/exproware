class CreateExperts < ActiveRecord::Migration[7.2]
  def change
    create_table :experts do |t|
      t.string :first_name
      t.string :last_name
      t.string :academic_title
      t.decimal :salary
      t.text :travel_willingness
      t.string :categories
      t.string :profile_image
      t.text :biography
      t.string :email
      t.string :password_digest
      t.string :unique_id

      t.timestamps
    end
  end
end
