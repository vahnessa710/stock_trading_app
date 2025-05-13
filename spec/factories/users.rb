# spec/factories/users.rb
FactoryBot.define do
    factory :user do
      email { "user@email.com" } # Default, override in tests when needed
      password { "password" }
      first_name { "firstname" }
      last_name { "lastname" }
      phone { "1234567890" }
      location { "manila" }
      confirmed_at { Time.now }
      confirmation_sent_at { Time.now }
      role { "trader" }
      status { "pending" }
  
      trait :admin do
        email { "admin@email.com" }
        role { "admin" }
        status { "approved" }
      end
  
      factory :specific_trader do
        email { "trader@email.com" }
        role { "trader" }
        first_name { "firstname" }
        last_name { "lastname" }
        phone { "1234567890" }
        location { "manila" }
        confirmed_at { Time.now }
        confirmation_sent_at { Time.now }
      end

      trait :pending do
        status { 'pending' }
      end
      
      trait :approved do
        status { 'approved' }
      end

      factory :specific_admin do
        email { "admin@email.com" }
        password { "password" }
        role { "admin" }
        confirmed_at { Time.now }
        confirmation_sent_at { Time.now }
      end
    end
  end