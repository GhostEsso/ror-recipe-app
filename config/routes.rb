Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check
  get '/public_recipes', to: 'recipes#public_recipes', as: 'public_recipes'

  devise_scope :user do
    authenticated :user do
      root :to => 'foods#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'recipes#public_recipes', as: :unauthenticated_root
    end
  end
  

  resources :recipes, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :recipe_foods
  end

  resources :foods, only: [:index, :new, :create, :destroy]

  resources :shopping_lists, only: [:index]

  # resources :users, only: [:show]
  # Defines the root path route ("/")
  # root "posts#index"
end
