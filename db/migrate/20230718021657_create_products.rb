class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :stripe_key
      t.string :name

      t.timestamps
    end
  end
end
