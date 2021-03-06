class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :project
      t.integer :contract_id
      t.string :doc_type
      t.string :doc_name
      t.integer :revision_number
      t.date :revision_date

      t.timestamps
    end
    add_index :documents, :project_id
    add_index :documents, :revision_date
  end
end
