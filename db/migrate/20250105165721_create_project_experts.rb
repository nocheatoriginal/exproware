class CreateProjectExperts < ActiveRecord::Migration[7.2]
  def change
    create_table :project_experts do |t|
      t.references :project, null: false, foreign_key: true
      t.references :expert, null: false, foreign_key: true

      t.timestamps
    end
  end
end
