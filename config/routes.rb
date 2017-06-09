Rails.application.routes.draw do
  post 'user_token' => 'user_token#create', as: 'user_token'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'blaab'=> 'application#authentication'
  resources :communes, :only => [:create, :index]
  resources :users, :only => [:create, :update]
end
