Rails.application.routes.draw do
  resources :recordings, only: [ :index, :create, :destroy ]

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
