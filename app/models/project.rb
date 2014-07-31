class Project < ActiveRecord::Base
  belongs_to :client
  attr_accessible :budget, :delivery_deadline, :status
end
