Rails.application.routes.draw do
  root to: 'scores#index'
  get '/login', to: 'user_sessions#new', as: :login
  post '/login', to: 'user_sessions#create'
  post '/guest_login', to: 'user_sessions#guest_login'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  resources :users,  only: %i[new show create edit update]
  resources :scores, only: %i[index new create edit update destroy] do
    resources :score_details, only: %i[index show create edit update destroy]
  end

  namespace :scores do
    resources :searches, only: :index do
      collection do
        get 'score'
        get 'check'
      end
    end
  end
end
