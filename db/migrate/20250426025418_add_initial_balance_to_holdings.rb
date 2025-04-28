class AddInitialBalanceToHoldings < ActiveRecord::Migration[8.0]
  def change
    add_column :holdings, :initial_balance, :decimal
  end
end
