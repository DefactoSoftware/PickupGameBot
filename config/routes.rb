Rails.application.routes.draw do
  root "static_pages#home"

  resource :games
end
