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
  resources :donations, only: [:create] do
    get 'success', on: :collection
    get 'cancel', on: :collection
  end
end
