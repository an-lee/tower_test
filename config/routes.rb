Rails.application.routes.draw do
  devise_for :users
  root 'teams#index'

  resources :teams do
    resources :projects
    resources :events
    member do
      post :join
      post :quit
    end
  end

  resources :projects do
    member do
      post :join
      post :quit
    end
    resources :todos do
      member do
        post :trash
        post :untrash
        post :complete
        post :uncomplete
        patch :assign
        patch :due
      end
    resources :messages
    end
  end

  resources :projects do
    resources :messages
  end

end
