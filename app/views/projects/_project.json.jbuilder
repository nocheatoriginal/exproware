json.extract! project, :id, :title, :description, :project_lead, :category, :time, :location, :todo_list, :participants, :document_storage, :created_at, :updated_at
json.url project_url(project, format: :json)
