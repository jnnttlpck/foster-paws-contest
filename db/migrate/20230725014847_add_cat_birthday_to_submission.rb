class AddCatBirthdayToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :cat_dob, :date
  end
end
