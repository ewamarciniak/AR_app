class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :reg_number
      t.string :phone_number
      t.string :fax_number
      t.references :address

      t.timestamps
    end
    add_index :companies, :address_id
  end
end
