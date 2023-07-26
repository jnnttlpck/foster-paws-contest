class RemoveEmailColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :email, :string
    remove_column :submissions, :email, :string
  end
end
