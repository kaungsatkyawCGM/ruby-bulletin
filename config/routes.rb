Rails.application.routes.draw do
  root "users#index"

  resources :users, only: [:index, :new, :show, :edit, :destroy]
  post '/users/new', to: 'users#create', as: 'create_user'
  post '/users/update/:id', to: 'users#update', as: 'updated_user'

  get '/download/user_list', to: 'users#download_pdf', as: 'download_user_list'
  post '/import_user_list', to: 'users#import_csv', as: 'import_user_list'

  get '/login', to: 'auth#login', as: 'login'
  post '/action-login', to: 'auth#action_login', as: 'action_login'
  get '/logout', to: 'auth#logout', as: 'action_logout'
  get '/register', to: 'auth#register', as: 'register'
  post '/register', to: 'auth#action_register', as: 'action_register'
end
