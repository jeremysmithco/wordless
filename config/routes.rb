Rails.application.routes.draw do
  resources :recordings, only: [ :index, :create, :destroy ]

  resource :session, only: [:new, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
