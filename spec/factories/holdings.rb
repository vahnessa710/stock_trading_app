# spec/factories/holdings.rb
FactoryBot.define do
  factory :holding do
    user
    symbol { 'AAPL' }
    quantity { 1 }
    buy_price { 150.00 }

    trait :deposit_params do
      balance { 1000 }
      payment_method {'Credit Card'}
    end

    trait :invalid_deposit_params do
      balance { 0 }
      payment_method {'Credit Card'}
    end
  end
end