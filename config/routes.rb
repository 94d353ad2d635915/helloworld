Rails.application.routes.draw do
  resource :settings, controller: 'profiles', only: [:show, :update, :destroy]

  root 'topics#index'
  resources :nodes, only: [:show]
  resources :topics do 
    resources :comments, only: [:create, :destroy]
  end
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :console do
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
    resources :nodes
    resources :avatars, only: [:index, :destroy]
    resources :comments, except: [:new, :create]
    resources :topics do 
      # resources :comments
      post 'comments', to: 'comments#create_from_topic'#, as: 'comments'
      delete 'comments/:id', to: 'comments#destroy_from_topic', as: 'comment'
    end
  end
end
