Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "api/v1/health#status"

  namespace :api do
    namespace :v1 do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
      post 'logout', to: 'auth#logout'
      delete 'todos', to: 'todos#destroy_all'
      post 'forgot_password', to: 'passwords#forgot'
      post 'reset_password',  to: 'passwords#reset'
      resources :todos
    end
  end
end
