class CreateProjectsTeamMembers < ActiveRecord::Migration
  def change
    create_table :projects_team_members, :id => false  do |t|
      t.references :project
      t.references :team_member

    end
    add_index :projects_team_members, :project_id
    add_index :projects_team_members, :team_member_id
  end
end