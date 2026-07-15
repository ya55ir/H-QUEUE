Rails.application.routes.draw do
  devise_for :users

  root "venues#index"

  resources :venues, only: [:index, :show] do
    member do
      get :qr_code
    end
    resource :queue_entry, only: [:new, :create]
  end

  resources :queue_entries, only: [:show] do
    member do
      get :confirmation
      patch :confirm
      patch :decline
    end
  end

  get "manager", to: "manager#show"
end
