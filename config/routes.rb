Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root "static_pages#home"

  get "static_pages/home"
  get "static_pages/contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users
  resources :tours, only: %i(index show) do
    resources :booking_tours, only: :create
  end
  
  resources :reviews

  resources :booking_tours, only: %i(index show edit update destroy)

  namespace :admin do
  end
end
