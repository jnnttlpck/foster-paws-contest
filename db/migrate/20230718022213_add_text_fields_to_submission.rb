class AddTextFieldsToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :got_cat, :text
    add_column :submissions, :about, :text
  end
end
