Rails.application.routes.draw do
  resources :notifications, only: [:index, :destroy]
  resources :credits, only: [:index]
  resource :settings, controller: 'profiles', only: [:show, :update]

  root 'topics#index'
  resources :nodes, param: :slug, only: [:show]
  resources :topics, except: [:destroy] do 
    resources :comments, only: [:create]
  end
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :console do
    resource :notifications, only: [:show, :destroy]
    resources :creditlogs, only: [:index, :show, :destroy]
    resources :credits, param: :user_id, except: [:edit] do
      member do
        get 'charge'
      end
    end
    resources :eventlogs, only: [:index, :show, :destroy]
    resources :events
    resources :profiles
    root to: "home#index", as: "root"
    patch 'roles/:id/permissions', to: 'roles#update_role_permissions', as: 'role_permissions'
    patch 'roles/:id/users', to: 'roles#update_role_users', as: 'role_users'
    resources :roles
    resources :menus
    get 'permissions', to: 'permissions#index'
    patch 'permissions', to: 'permissions#update'
    resources :nodes, param: :slug
    resources :comments, except: [:new, :create]
    resources :topics do 
      # resources :comments
      post 'comments', to: 'comments#create_from_topic'#, as: 'comments'
      delete 'comments/:id', to: 'comments#destroy_from_topic', as: 'comment'
    end
    resources :options
    delete :options, to: 'options#reset'
  end
end
