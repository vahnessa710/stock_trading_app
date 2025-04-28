class Holding < ApplicationRecord
  belongs_to :user
  validates :initial_balance, numericality: { greater_than_or_equal_to: 0 }
  validates :symbol, presence: true
  validates :quantity, presence: true
end
