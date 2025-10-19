Rails.application.routes.draw do
  resources :tracks, shallow: true, only: [:create, :show, :destroy] do
    resources :recordings, only: [:create, :destroy]
  end

  resources :users, only: [:show]

  resource :session, only: [:new, :destroy]
  resource :avatar, only: [:new, :update, :destroy]
  resource :account, only: [:show]

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
