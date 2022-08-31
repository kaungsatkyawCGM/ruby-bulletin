Rails.application.routes.draw do
  root "users#index"

  resources :users, only: [:index, :new, :show, :edit, :destroy]
  post '/users/new', to: 'users#create', as: 'create_user'

  get '/download/user_list', to: 'users#download_pdf', as: 'download_user_list'
  post '/import_user_list', to: 'users#import_csv', as: 'import_user_list'
end
