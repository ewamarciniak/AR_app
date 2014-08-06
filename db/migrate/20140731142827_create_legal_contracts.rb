class CreateLegalContracts < ActiveRecord::Migration
  def change
    create_table :legal_contracts do |t|
      t.references :project
      t.string :title
      t.date :signed_on
      t.date :revised_on
      t.string :copy_stored

      t.timestamps
    end
    add_index :legal_contracts, :project_id
  end
end
