class CreateProjectTeamMembers < ActiveRecord::Migration
  def change
    create_table :project_team_members, :id => false  do |t|
      t.references :project
      t.references :team_member

      t.timestamps
    end
    add_index :project_team_members, :project_id
    add_index :project_team_members, :team_member_id
  end
end