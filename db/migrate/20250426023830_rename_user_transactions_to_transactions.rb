class RenameUserTransactionsToTransactions < ActiveRecord::Migration[8.0]
  def change
    rename_table :user_transactions, :transactions
  end
end
