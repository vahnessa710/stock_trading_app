class RemoveInitialBalanceFromHoldings < ActiveRecord::Migration[8.0]
  def change
    remove_column :holdings, :initial_balance, :decimal
  end
end
