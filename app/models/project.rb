class Project < ActiveRecord::Base
  belongs_to :client
  has_and_belongs_to_many :team_members
  #has_many :team_members
  #has_many :team_members, through: :projects_team_members
  has_one :legal_contract
  has_many :documents
  attr_accessible :budget, :delivery_deadline, :status
end
