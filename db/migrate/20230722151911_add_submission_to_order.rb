class AddSubmissionToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :submission, foreign_key: true
  end
end
