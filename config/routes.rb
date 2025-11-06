Rails.application.routes.draw do
  # Super Admin routes
  get    'superadmin/sign_in',         to: 'superadmins#sign_in'
  post   'superadmin/login',           to: 'superadmins#login'
  get    'superadmin/dashboard',       to: 'superadmins#dashboard'
  delete 'superadmin/users/:id',       to: 'superadmins#destroy_user',       as: 'superadmin_delete_user'
  delete 'superadmin/events/:id',      to: 'superadmins#destroy_event',      as: 'superadmin_delete_event'
  delete 'superadmin/messages/:id',    to: 'superadmins#destroy_message',    as: 'superadmin_delete_message'
  delete 'superadmin/announcements/:id', to: 'superadmins#destroy_announcement', as: 'superadmin_delete_announcement'
  get    'superadmin/admins/new',      to: 'superadmins#new_admin',          as: 'new_superadmin_admin'
  post   'superadmin/admins',          to: 'superadmins#create_admin',       as: 'create_superadmin_admin'
  root "events#index"
  resources :users
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  # Google OAuth2 callback route (important)
  get '/auth/:provider/callback', to: 'users#google_auth'
  get '/auth/failure', to: redirect('/')
  get '/verify', to: 'users#verify_email'

  resources :events do
    resources :registrations, only: [:new, :create, :destroy, :index]
    resources :announcements, only: [:create, :destroy, :index]
    resources :messages, only: [:create, :index]
  end

  mount ActionCable.server => '/cable'
end
