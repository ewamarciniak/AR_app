class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :client
      t.float :budget
      t.date :delivery_deadline
      t.string :status

      t.timestamps
    end
    add_index :projects, :client_id
  end
end
