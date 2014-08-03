class ProjectsTeamMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :team_member
  # attr_accessible :title, :body
end
