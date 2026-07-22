Rails.application.routes.draw do
  devise_for :users

  root "venues#index"

  # Render dynamic PWA files from app/views/pwa/* (linked in shared/_head)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

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

  namespace :manager do
    resources :venues, only: %i[index show]

    resources :queue_entries, only: [] do
      member do
        patch :notify
      end
    end
  end

# Expose les composants front de l'app à destination des devs
  get "style_guide", to: "pages#style_guide"
end
