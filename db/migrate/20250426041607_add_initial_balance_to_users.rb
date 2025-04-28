class AddInitialBalanceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :initial_balance, :decimal, default: 0.0, null: false
  end
end
