Rails.application.routes.draw do
  root 'topics#index'
  resources :topics do 
    resources :comments, only: [:create, :update, :destroy]
  end
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :console do
    resources :comments, except: [:new, :create]
    resources :topics do 
      # resources :comments
      post 'comments', to: 'comments#create_from_topic'#, as: 'comments'
      delete 'comments/:id', to: 'comments#destroy_from_topic', as: 'comment'
    end
  end
end
