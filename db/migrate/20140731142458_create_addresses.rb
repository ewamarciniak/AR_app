class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :postcode
      t.string :city
      t.string :county

      t.timestamps
    end
  end
end
