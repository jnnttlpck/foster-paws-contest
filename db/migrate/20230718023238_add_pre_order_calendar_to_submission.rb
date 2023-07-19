class AddPreOrderCalendarToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :pre_order_calendar, :boolean, default: false
    add_column :submissions, :pre_order_quantity, :integer
  end
end
