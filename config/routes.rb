Rails.application.routes.draw do
  root to: "home#index"
  get "/tasks", to: "home#index"
  get "/task/new", to: "home#index"
  get "/task/:id/edit", to: "home#index"

  get "/action_records", to: "home#index"

  devise_for :users

  namespace :api, format: "json" do
    resources :tasks
    resources :action_records
  end
end
