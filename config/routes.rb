Rails.application.routes.draw do
  root "static_pages#home"

  resources :games, only: [:show, :index]
end
