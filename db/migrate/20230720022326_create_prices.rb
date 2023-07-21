class CreatePrices < ActiveRecord::Migration[7.0]
  def change
    create_table :prices do |t|
      t.references :product, null: false, foreign_key: true
      t.string :stripe_key
      t.boolean :transaction_fee, default: false

      t.timestamps
    end
  end
end
