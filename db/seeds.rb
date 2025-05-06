# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = User.create!(
  email: "admin@email.com",
  password: "password",
  password_confirmation: "password",
  role: "admin",
  status: "approved",
  confirmed_at: Time.now,
  confirmation_sent_at: Time.now,
  first_name: "admin name",
  last_name: "admin last name",
  location: "Philippines",
  phone: '09171234658'
)