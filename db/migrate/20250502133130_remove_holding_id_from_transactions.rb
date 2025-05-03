class RemoveHoldingIdFromTransactions < ActiveRecord::Migration[8.0]
  def change
    remove_column :transactions, :holding_id, :bigint
  end
end
