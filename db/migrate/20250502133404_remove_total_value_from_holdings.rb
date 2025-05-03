class RemoveTotalValueFromHoldings < ActiveRecord::Migration[8.0]
  def change
    remove_column :holdings, :total_value, :decimal
  end
end
