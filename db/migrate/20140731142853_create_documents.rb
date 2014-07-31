class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :project
      t.string :type
      t.integer :revision_number

      t.timestamps
    end
    add_index :documents, :project_id
  end
end
