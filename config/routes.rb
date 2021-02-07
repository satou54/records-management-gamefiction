Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  get "/tasks", to: "home#index"
  get "/task/new", to: "home#index"
  get "/task/edit", to: "home#index"

  namespace :api, format: "json" do
    resources :tasks
  end
end
