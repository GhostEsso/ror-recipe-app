Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check
  get '/public_recipes', to: 'recipes#public_recipes', as: 'public_recipes'
  
  devise_scope :user do
    authenticated :user do
      root :to => 'recipes#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'recipes#public_recipes', as: :unauthenticated_root
    end
  end

  resources :users do
    resources :foods, only: [:index, :show, :new, :create, :destroy]
    resources :recipes, only: [:index, :new, :create, :show, :destroy]
  end

  resources :recipes, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :recipe_foods
  end

  resources :foods, only: [:index, :show, :new, :create, :destroy]

  # Defines the root path route ("/")
  # root "posts#index"
end
