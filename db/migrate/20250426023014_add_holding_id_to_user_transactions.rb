class AddHoldingIdToUserTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :user_transactions, :holding, null: false, foreign_key: true
  end
end
