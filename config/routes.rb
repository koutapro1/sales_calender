Rails.application.routes.draw do
  get 'users/new'
  resources :user
  resources :sales
end
