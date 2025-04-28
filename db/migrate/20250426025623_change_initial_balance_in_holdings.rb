class ChangeInitialBalanceInHoldings < ActiveRecord::Migration[8.0]
  def change
    change_column :holdings, :initial_balance, :decimal, default: 0.0, null: false
  end
end
