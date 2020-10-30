require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/api_documentation"

  devise_for :users
  root "landing#index"
  get "home/index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
