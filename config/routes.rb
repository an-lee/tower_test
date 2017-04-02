Rails.application.routes.draw do
  devise_for :users
  root 'teams#index'

  resources :teams do
    resources :projects
    resources :events
  end

  resources :projects do
    resources :todos
  end

  resources :projects do
    resources :messages
  end

end
