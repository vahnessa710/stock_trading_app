class RenameInitialBalanceToBalanceInUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :initial_balance, :balance
  end
end
