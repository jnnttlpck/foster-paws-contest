class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.references :product, null: false, foreign_key: true
      t.string :email
      t.integer :status

      t.timestamps
    end
  end
end
