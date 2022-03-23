Rails.application.routes.draw do

  root to: 'scores#index'
  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'user_sessions/destroy'
  get '/login', to: 'user_sessions#new', as: :login
  post '/login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  namespace :scores do
    resources :searches, only: :index do
      get 'score', on: :collection, defaults: { format: :json }
    end
  end

  resources :users,  only: [:new, :show, :create, :edit, :update]
  resources :scores, only: [:index, :new, :create, :destroy]
end
