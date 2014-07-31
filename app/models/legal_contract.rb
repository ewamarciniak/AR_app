class LegalContract < ActiveRecord::Base
  belongs_to :project
  attr_accessible :copy_stored, :revised_on, :signed_on
end
