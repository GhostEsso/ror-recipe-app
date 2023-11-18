Rails.application.routes.draw do
  devise_for :users
  get '/public_recipes', to: 'recipes#public_recipes', as: 'public_recipes'
  get '/recipes/:recipe_id/shopping_list', to: 'recipes#shopping_list', as: 'shopping_list'
  devise_scope :user do
    authenticated :user do
      root :to => 'recipes#index', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'recipes#public_recipes', as: :unauthenticated_root
    end
  end
  
  resources :users, only: [] do
    resources :foods, only: [:index, :show, :new, :create, :destroy]
    resources :recipes, only: [:index, :new, :create, :show, :destroy]
  end

  resources :recipes, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :recipe_foods
  end

  resources :foods, only: [:index, :new, :create, :destroy]
  root 'render#index'
end
