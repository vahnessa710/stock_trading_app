Rails.application.routes.draw do
  devise_for :users
    resources :holdings do
      resources :transactions
      collection do
        get :deposit   # show the deposit form
        post :deposit  # submit the deposit
      end
    end
    
  namespace :admin do
    resources :users do
      member do
        patch :approve_user
      end
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  authenticated :user do
    root to: "holdings#index", as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
