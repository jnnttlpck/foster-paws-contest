class AddUserToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_reference :submissions, :user, null: false, foreign_key: true
  end
end
