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
  delete 'communes/:commune_id/tasks/:task_id' => 'task_completions#destroy'

  # User adding routes
  post 'communes/:commune_id/invite' => 'commune_users#invite'
  post 'invitations/:invitation_id/accept' => 'commune_users#accept_invitation'
  post 'invitations/:invitation_id/reject' => 'commune_users#reject_invitation'
  delete 'invitations/:invitation_id' => 'commune_users#cancel_invitation'

  # Demote / promote
  post 'communes/:commune_id/promote/:user_id' => 'commune_users#promote'
  post 'communes/:commune_id/demote/:user_id' => 'commune_users#demote'
  delete 'communes/:commune_id/remove_user/:user_id' => 'commune_users#remove_user'


end
