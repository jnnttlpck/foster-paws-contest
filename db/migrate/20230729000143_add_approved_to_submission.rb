class AddApprovedToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :approved, :boolean
  end
end
