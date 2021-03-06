Rails.application.routes.draw do
  root to: "home#index"

  get "/signup", to: "home#index"
  get "/login", to: "home#index"
  get "/account", to: "home#index"

  get "/mypage", to: "home#index"
  get "/tasks", to: "home#index"
  get "/task/new", to: "home#index"
  get "/task/:id/edit", to: "home#index"

  get "/action_records", to: "home#index"
  get "/action_records/references", to: "home#index"

  devise_for :users

  namespace :api, format: "json" do
    mount_devise_token_auth_for "User", at: "auth", controllers: {
                                          registrations: "api/auth/registrations",
                                        }
    resources :tasks
    resources :action_records do
      get "actionRecordReferences", :on => :collection
    end
    resource :user_levels, only: [:create, :show]
  end
end
