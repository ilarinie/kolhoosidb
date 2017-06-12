Rails.application.routes.draw do
  post 'user_token' => 'user_token#create', as: 'user_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'current_user' => 'users#showCurrent'
  resources :communes, :only => [:create, :index]
  resources :users, :only => [:create, :update]
  put 'change_password' => 'users#change_password'
end
