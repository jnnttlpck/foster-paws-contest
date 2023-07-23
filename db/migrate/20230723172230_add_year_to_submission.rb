class AddYearToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :year, :integer
  end
end
