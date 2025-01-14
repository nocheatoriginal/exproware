class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.text :project_lead
      t.text :todo_list
      t.text :participants
      t.text :document_storage

      t.timestamps
    end
  end
end
