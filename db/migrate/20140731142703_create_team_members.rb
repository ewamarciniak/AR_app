class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.string :team
      t.string :experience_level
      t.string :qualification
      t.boolean :lead

      t.timestamps
    end
  end
end
