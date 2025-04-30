class Holding < ApplicationRecord
  belongs_to :user
  validates :symbol, presence: true
  validates :quantity, presence: true
  scope :owned, -> { where("quantity > 0") }
  scope :consolidated_by_symbol, -> {
    select("symbol, SUM(quantity) AS total_quantity, SUM(quantity * buy_price) AS total_value")
      .group(:symbol)
      .order(:symbol)
  } #for max sell, consoldidated total quantity per symbol
  scope :actual_holdings_for, ->(symbol) {where(symbol: symbol).where("quantity > 0").order(:created_at)}
end
