class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_type
      t.string :symbol
      t.integer :quantity

      t.timestamps
    end
  end
end
