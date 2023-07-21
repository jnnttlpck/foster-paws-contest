class AddCoverTransactioneeToLineItem < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :cover_transaction_fee, :boolean, default: false
  end
end
