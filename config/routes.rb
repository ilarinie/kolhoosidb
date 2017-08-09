Rails.application.routes.draw do
  apipie
  post 'usertoken' => 'user_token#create', as: 'user_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'current_user' => 'users#showCurrent'
  resources :communes, :only => [:create, :index, :show, :destroy, :update]
  resources :users, :only => [:create, :update, :index]
  post 'invitation' => 'commune_users#adduser', as: 'invitation'
end
