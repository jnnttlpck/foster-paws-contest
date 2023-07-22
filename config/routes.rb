Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  resources :submissions do
    get 'success'
    get 'cancel'
    get 'add_order', on: :collection
  end
  resources :orders do
    get 'success'
    get 'cancel'
  end
end
