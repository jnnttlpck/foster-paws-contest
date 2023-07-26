class AddCatAgeToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :cat_age, :string
  end
end
