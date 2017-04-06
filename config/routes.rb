Rails.application.routes.draw do
  devise_for :users
  root 'teams#index'

  resources :teams do

    member do
      post :join
      post :quit
    end

    resources :events, only: [:index]

    resources :projects do
      member do
        post :join
        post :quit
      end
    end

  end

  resources :projects do
    resources :todos, only: [:new, :create, :edit, :update, :destroy, :show] do
      member do
        post :trash
        post :untrash
        post :complete
        post :uncomplete
        patch :assign
        patch :due
      end
    resources :messages, only: [:create, :new]
    end
  end

  resources :projects do
    resources :messages
  end

end
