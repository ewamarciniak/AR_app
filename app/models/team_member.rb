class TeamMember < ActiveRecord::Base
  #has_many :projects_team_members
  #has_many :projects, through: :projects_team_members
  has_one :person, as: :profile, dependent: :destroy
  has_and_belongs_to_many :projects
  attr_accessible :person_attributes,:experience_level, :lead, :qualification, :team
  accepts_nested_attributes_for :person
end
