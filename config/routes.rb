Rails.application.routes.draw do
  get "home/index"
  namespace :admin do
    resources :users, only: [ :index, :new, :create, :edit, :update, :destroy ] do
      patch :update_role, on: :member
      patch :update_username, on: :member
      get :show, on: :member
      delete :delete_one_time_link, on: :collection, to: 'users#delete_one_time_link', as: 'delete_one_time_link'
    end
  end

  get 'profile/:id', to: 'admin/users#show', as: :profile

  get "projects/archived", to: "projects#archived", as: :archived_projects

  resources :projects do
    resources :project_experts, only: [:create, :destroy]
    get 'available_experts', to: 'project_experts#available_experts'
  end  


  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  devise_scope :user do
    get 'users/sign_up', to: redirect('/'), constraints: lambda { |req| req.params[:token].blank? }
    get 'signup/:token', to: 'users/registrations#handle_token', as: 'signup_with_token'
  end


  match "users/:id" => "users#destroy", :via => :delete, :as => :admin_destroy_user


  resources :categories
  resources :experts
  resources :projects do
    member do
      delete 'files/:file_type/:attachment_id', to: 'projects#remove_file', as: 'remove_file'
      get 'files/:file_type/:attachment_id', to: 'projects#show_file', as: 'show_file'
    end
  end
  resources :posts
  get 'experts/edit/:unique_id', to: 'experts#edit_with_password', as: 'edit_expert_with_password'
  patch 'experts/edit/:unique_id/verify_password', to: 'experts#verify_password', as: 'verify_expert_password'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root route
  root "home#index"

  # Catch-all route for 404 handling
  match "*unmatched", to: "application#not_found_route", via: :all
end

