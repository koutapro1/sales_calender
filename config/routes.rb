Rails.application.routes.draw do

  root to: 'scores#index'
  get '/login', to: 'user_sessions#new', as: :login
  post '/login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  namespace :scores do
    resources :searches, only: :index do
      collection do
        get 'score'
        get 'check'
      end
    end
  end

  resources :users,  only: [:new, :show, :create, :edit, :update]
  resources :scores, only: [:index, :new, :create, :edit, :update, :destroy] do
    resources :score_details, only: [:index, :show, :create]
  end
end
