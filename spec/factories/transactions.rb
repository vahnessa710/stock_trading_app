FactoryBot.define do
    factory :transaction do
        user
        transaction_type { 'buy' }
        symbol { 'AAPL' }
        quantity { 1 }
        amount { 150.00 }
    end
end