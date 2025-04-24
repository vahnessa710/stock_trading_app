class DropTransactionsTable < ActiveRecord::Migration[8.0]
  def up
    drop_table :transactions
  end
  
  def down
    create_table :transactions do |t|
      t.string "transaction_type"
      t.string "symbol"
      t.integer "quantity"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
