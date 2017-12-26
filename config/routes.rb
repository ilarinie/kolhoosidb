Rails.application.routes.draw do
  apipie
  post 'usertoken' => 'user_token#create', as: 'user_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'current_user' => 'users#showCurrent'
  resources :communes, :only => [:create, :index, :show, :destroy, :update], param: :commune_id
  resources :users, :only => [:create, :update]

  get 'communes/:commune_id/users' => 'users#index'

  # Task routes
  post 'communes/:commune_id/tasks' => 'tasks#create'
  put 'communes/:commune_id/tasks/:task_id' => 'tasks#update'
  delete 'communes/:commune_id/tasks/:task_id' => 'tasks#destroy'
  get 'communes/:commune_id/tasks' => 'tasks#index'
  post 'communes/:commune_id/tasks/:task_id/complete' => 'task_completions#complete'
  delete 'communes/:commune_id/task_completions/:task_completion_id' => 'task_completions#destroy'

  # User adding/removing routes
  post 'communes/:commune_id/invite' => 'commune_users#invite'
  post 'invitations/:invitation_id/accept' => 'commune_users#accept_invitation'
  post 'invitations/:invitation_id/reject' => 'commune_users#reject_invitation'
  delete 'invitations/:invitation_id' => 'commune_users#cancel_invitation'

  # User "own" routes
  get 'users/:user_id' => 'users#show_current'
  delete 'communes/:commune_id/leave' => 'commune_users#leave'
  post 'users/change_password' => 'users#change_password'

  # Demote / promote
  post 'communes/:commune_id/promote/:user_id' => 'commune_users#promote_to_admin'
  post 'communes/:commune_id/demote/:user_id' => 'commune_users#demote'
  delete 'communes/:commune_id/remove_user/:user_id' => 'commune_users#remove_user'

  # Purchases
  get 'communes/:commune_id/purchases' => 'purchases#index'
  post 'communes/:commune_id/purchases' => 'purchases#create'
  delete 'communes/:commune_id/purchases/:purchase_id' => 'purchases#cancel'
  post 'communes/:commune_id/purchases/cancel_last' => 'purchases#cancel_last'
  get 'communes/:commune_id/budget' => 'purchases#budget'

  # Purchase Categories
  get 'communes/:commune_id/purchase_categories' => 'purchase_categories#index'
  post 'communes/:commune_id/purchase_categories' => 'purchase_categories#create'
  put 'communes/:commune_id/purchase_categories/:purchase_category_id' => 'purchase_categories#update'
  delete 'commune/:commune_id/purchase_categories/:purchase_category_id' => 'purchase_categories#destroy'

  # Refunds
  post 'communes/:commune_id/refunds' => 'refunds#create'
  post 'communes/:commune_id/refunds/:refund_id/confirm' => 'refunds#confirm'
  post 'communes/:commune_id/refunds/:refund_id/reject' => 'refunds#reject'
  delete 'communes/:commune_id/refunds/:refund_id/cancel' => 'refunds#cancel'

  # Activity Feed
  get 'communes/:commune_id/activity_feed' => 'activity#index'

  # Top Lists
  get 'communes/:commune_id/top_list' => 'top_list#index'

end
