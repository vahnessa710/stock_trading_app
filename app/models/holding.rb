class Holding < ApplicationRecord
  belongs_to :user
  validates :symbol, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :buy_price, numericality: { greater_than: 0 }

  scope :owned, -> { where("quantity > 0") }
  scope :consolidated_by_symbol, -> {
    select("symbol, SUM(quantity) AS total_quantity, SUM(quantity * buy_price) AS total_value")
      .group(:symbol)
      .order(:symbol)
  }
  scope :actual_holdings_for, ->(symbol) {where(symbol: symbol).where("quantity > 0").order(:created_at)}
end
