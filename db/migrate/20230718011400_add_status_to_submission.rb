class AddStatusToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :status, :integer
  end
end
