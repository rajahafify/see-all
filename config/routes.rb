require 'sidekiq/web'

Rails.application.routes.draw do
  root "streams#index"

  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :streams, only: [:show] do
    post :start, on: :collection
    post :stop, on: :collection
    post :auth, on: :collection
  end
end
