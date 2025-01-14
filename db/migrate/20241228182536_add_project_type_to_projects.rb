class AddProjectTypeToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :project_type, :integer
  end
end
