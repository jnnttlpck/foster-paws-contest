class AddDeliveryOptionToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :delivery_option, :integer, default: 0
  end
end
