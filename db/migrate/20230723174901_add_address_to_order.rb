class AddAddressToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :name, :string
    add_column :orders, :line_1, :string
    add_column :orders, :line_2, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :zip, :string
  end
end
