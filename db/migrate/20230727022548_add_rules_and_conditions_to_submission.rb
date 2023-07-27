class AddRulesAndConditionsToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :rules_and_conditions, :boolean, default: false
  end
end
