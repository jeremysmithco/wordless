Rails.application.routes.draw do
  resources :recordings, only: [:create, :destroy]
  resources :tracks, only: [:create, :show, :destroy]

  resource :session, only: [:new, :destroy]
  resource :avatar, only: [:new, :update, :destroy]
  resource :account, only: [:show]

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
