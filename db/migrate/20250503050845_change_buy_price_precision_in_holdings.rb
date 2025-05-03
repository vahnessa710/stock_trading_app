class ChangeBuyPricePrecisionInHoldings < ActiveRecord::Migration[8.0]
  def change
    change_column :holdings, :buy_price, :decimal, precision: 10, scale: 2
  end
end
