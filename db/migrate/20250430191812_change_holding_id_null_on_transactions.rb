class ChangeHoldingIdNullOnTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :transactions, :holding_id, true
  end
end
