Rails.application.routes.draw do
  devise_for :users
    resources :holdings
  
    resources :transactions, only: [:index]

    resources :trades, only: [] do
      collection do
        get :fetch_buy_price
        get :fetch_sell_price
        get :buy,  to: "trades#new_buy"
        post :buy, to: "trades#create_buy"
  
        get :sell, to: "trades#new_sell"
        post :sell, to: "trades#create_sell"
      end
    end

    namespace :users do
      get 'profile', to: 'profiles#show'
    end    

    namespace :admin do
      resources :users do
        member do
          patch :approve_user
        end
        collection do
          get :transactions
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
