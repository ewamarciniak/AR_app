class Company < ActiveRecord::Base
  belongs_to :address
  attr_accessible :company_name, :fax_number, :phone_number, :reg_number

  def team_members_present?
    require 'debugger'; debugger
    self.people.any?
  end
end
