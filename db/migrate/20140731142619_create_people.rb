class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.references :company
      t.integer :profile_id
      t.string :profile_type

      t.timestamps
    end
    add_index :people, :company_id
  end
end
