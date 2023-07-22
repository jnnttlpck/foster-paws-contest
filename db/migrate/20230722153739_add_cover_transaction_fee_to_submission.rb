class AddCoverTransactionFeeToSubmission < ActiveRecord::Migration[7.0]
  def change
    add_column :submissions, :cover_transaction_fee, :boolean, default: false
  end
end
