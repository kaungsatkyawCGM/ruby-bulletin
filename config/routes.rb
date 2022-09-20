Rails.application.routes.draw do
  root "users#index"

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  resources :users, only: [:index, :new, :show, :edit, :destroy]
  post '/users/new', to: 'users#create', as: 'create_user'
  post '/users/:id/edit', to: 'users#update', as: 'updated_user'
  get '/change-password', to: 'users#change_password', as: 'change_password'
  post '/change-password', to: 'users#action_change_password', as: 'change_password_action'
  post '/users/list', to: 'users#user_list'

  get '/download/user_list', to: 'users#download_csv', as: 'download_user_list'
  post '/import_user_list', to: 'users#import_csv', as: 'import_user_list'

  get '/login', to: 'auth#login', as: 'login'
  post '/login', to: 'auth#action_login', as: 'action_login'
  get '/logout', to: 'auth#logout', as: 'action_logout'
  get '/register', to: 'auth#register', as: 'register'
  post '/register', to: 'auth#action_register', as: 'action_register'
  get '/password', to: 'auth#reset_password_mail', as: 'password_reset_mail'
  post '/password', to: 'auth#sent_reset_password_mail', as: 'sent_password_reset_mail'
  get '/password-reset', to: 'auth#password_reset', as: 'password_reset'
  post '/password-reset', to: 'auth#action_password_reset', as: 'action_password_reset'

  resources :posts, only: [:index, :new]
  post '/posts', to: 'posts#create', as: 'create_post'
  delete '/profile/:id/post/:post_id', to: 'posts#destroy', as: 'delete_post'

  get '/profile/:id/posts', to: 'posts#profile_post', as: 'user_posts'
  post '/profile/:id/posts', to: 'posts#create', as: 'create_user_post'
  get '/post/:post_id/edit', to: 'posts#edit', as: 'edit_post'
  post '/post/:post_id/edit', to: 'posts#update', as: 'update_post'
end
