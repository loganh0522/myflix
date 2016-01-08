Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  resources :videos do 
    collection do 
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do 
    resources :videos, only: [:new, :create]
  end
  get 'people', to: 'relationships#index'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"
  

  resources :relationships, only: [:create, :destroy]
  resources :users, only: [:show]
  resources :queue_items 
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :category
  
  post 'update_queue', to: 'queue_items#update_queue'

  get 'forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: "password_resets#expired_token"

  resources :password_resets, only: [:show, :create]

  resources :invitations 

  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  mount StripeEvent::Engine, at: '/stripe_events'
end
