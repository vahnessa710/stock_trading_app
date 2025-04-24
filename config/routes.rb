Rails.application.routes.draw do
  devise_for :users
    resources :holdings do
      resources :user_transactions
    end
  
  resource :admin_users
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  authenticated :user do
    root to: "holdings#index", as: :authenticated_root_path
  end

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
