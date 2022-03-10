Rails.application.routes.draw do

  root to: 'scores#index'
  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'
  get '/login', to: 'user_sessions#new', as: :login
  post '/login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  namespace :scores do
    resources :searches, only: :index, defaults: { format: :json }
  end

  resources :users
  resources :scores
end
