class AddTotalValueToHoldings < ActiveRecord::Migration[8.0]
  def change
    add_column :holdings, :total_value, :decimal, precision: 15, scale: 2
  end
end
