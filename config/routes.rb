Rails.application.routes.draw do
  devise_for :users
  root 'teams#index'

  resources :teams do
    resources :projects
    resources :events
  end

  resources :projects do
    resources :todos do
      member do
        post :trash
        post :untrash
        post :complete
        post :uncomplete
        patch :assign
        patch :due
      end
    end
  end

  resources :projects do
    resources :messages
  end

end
