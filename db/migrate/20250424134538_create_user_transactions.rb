class CreateUserTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_transactions do |t|
      t.string :transaction_type
      t.string :symbol
      t.integer :quantity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
