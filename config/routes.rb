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
  get "/reviews/from_url", to: "reviews#from_url_view"
  post "/reviews/from_url", to: "reviews#from_url"

  resources :users
  resources :reviews
  resources :booking_tours, only: %i(index show edit update destroy)
  resources :tours, only: %i(index show) do
    resources :booking_tours, only: :create
    resources :reviews, only: %i(new create)
    collection do
      get "search"
    end
  end


  namespace :admin do
    resources :booking_tours do
      member do
        patch "approved", to: "booking_tours#approved_booking"
        patch "rejected", to: "booking_tours#rejected_booking"
        patch "pending", to: "booking_tours#pending_booking"
      end
    end
    resources :reviews, only: %i(index show) do
      member do
        patch "rejected", to: "reviews#rejected"
        patch "public_view", to: "reviews#public_view"
      end
    end
    get 'dashboards/index'
  end
end
