class Document < ActiveRecord::Base
  belongs_to :project
  attr_accessible :revision_number, :type
end
