class CreateHoldings < ActiveRecord::Migration[8.0]
  def change
    create_table :holdings do |t|
      t.string :symbol
      t.integer :quantity
      t.decimal :buy_price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
