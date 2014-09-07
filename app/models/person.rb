class Person < ActiveRecord::Base
  belongs_to :company
  attr_accessible :email, :first_name, :last_name, :phone_number, :profile_id, :profile_type,

  def name_and_company
    name = self.first_name + ' ' + self.last_name
    name = name + ' / ' +  self.company.company_name if self.company && self.company.company_name
    return name
  end

end

