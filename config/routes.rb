Rails.application.routes.draw do
  root "events#index"

  resources :users
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  resources :events do
    resources :registrations, only: [:new, :create, :destroy, :index]
    resources :announcements, only: [:create, :destroy, :index]
    resources :messages, only: [:create, :index]
  end

  mount ActionCable.server => '/cable'
end
