Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  get "/tasks", to: "home#index"
  get "/tasks/new", to: "home#index"
  get "/tasks/:id/edit", to: "home#index"

  namespace :api, format: "json" do
    resources :tasks
  end
end
