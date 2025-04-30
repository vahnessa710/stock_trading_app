class Transaction < ApplicationRecord
  belongs_to :user
  def buy?
    transaction_type == "buy"
  end
  def sell?
    transaction_type == "sell"
  end
  scope :deposits, -> { where(transaction_type: "deposit") }
  scope :stock_trades, -> { where(transaction_type: ["buy", "sell"]) }
  scope :recent_first, -> { order(created_at: :desc) }
end
