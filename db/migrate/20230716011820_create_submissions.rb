class CreateSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :submissions do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :pet_name
      t.string :location

      t.timestamps
    end
  end
end
