class UpdateProject < ActiveRecord::Migration[7.2]
  def change
    #removing old fields
    remove_column :projects, :title, :string
    remove_column :projects, :description, :text
    remove_column :projects, :project_lead, :string
    remove_column :projects, :todo_list, :text
    remove_column :projects, :participants, :text
    remove_column :projects, :document_storage, :string

    #adding new fields
    add_column :projects, :project_title, :string
    add_column :projects, :thematic_focus, :string
    add_column :projects, :start_date, :date
    add_column :projects, :end_date, :date
    add_column :projects, :project_type, :string
    add_column :projects, :client, :string
    add_column :projects, :location, :string
    add_column :projects, :target_group, :text
    add_column :projects, :invitation_status, :string
    add_column :projects, :participation_certificate_status, :string
  end
end
