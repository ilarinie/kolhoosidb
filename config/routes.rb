Rails.application.routes.draw do
  apipie
  post 'usertoken' => 'user_token#create', as: 'user_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'current_user' => 'users#showCurrent'
  resources :communes, :only => [:create, :index, :show, :destroy, :update], param: :commune_id
  resources :users, :only => [:create, :update, :index]
  post 'invitation' => 'commune_users#adduser', as: 'invitation'



  # Task routes
  post 'communes/:commune_id/tasks' => 'tasks#create'
  put 'communes/:commune_id/tasks/:task_id' => 'tasks#update'
  delete 'communes/:commune_id/tasks/:task_id' => 'tasks#destroy'
  get 'communes/:commune_id/tasks' => 'tasks#index'

  post 'communes/:commune_id/tasks/:task_id/complete' => 'task_completions#complete'


end
