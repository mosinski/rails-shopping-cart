Rails.application.routes.draw do
  root to: 'categories#index'

  resources :categories, only: [:index] do
    resources :products, only: [:index]
  end

  get '/cart', to: 'order_items#index'
  resources :order_items, path: '/cart/items'
  resources :checkouts,  only: [:index, :new, :create, :show]
end
