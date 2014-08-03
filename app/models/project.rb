class Project < ActiveRecord::Base
  belongs_to :client
  has_and_belongs_to_many :team_members
  attr_accessible :budget, :delivery_deadline, :status
end
