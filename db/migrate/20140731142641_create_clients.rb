class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :pref_method_of_contact
      t.string :pref_hours_of_contact

      t.timestamps
    end
  end
end
