Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :submissions do
    get 'success'
  end
end
