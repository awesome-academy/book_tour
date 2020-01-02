Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  resources :account_activations, only: [:edit]
  resources :bookings do
    member do
      patch :change_status
      put :change_status
      patch :recover
      put :recover
      delete :purge
      post :hook
      get :pay
    end
  end
  resources :categories
  resources :comments do
    resources :comments
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :revenues
  resources :reviews do
    resources :comments
    resources :likes
  end
  resources :tours do
    member do
      patch :recover
      put :recover
      delete :purge
    end
  end
  resources :tour_details do
    member do
      patch :recover
      put :recover
      delete :purge
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks",
                                    registrations: "users/registrations",
                                    sessions: "users/sessions",
                                    passwords: "users/passwords",
                                    confirmations: "users/confirmations" }
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  end
