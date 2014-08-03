class Person < ActiveRecord::Base
  belongs_to :company
  attr_accessible :email, :first_name, :last_name, :phone_number, :profile_id, :profile_type,

  def name_and_company
    self.first_name + ' ' + self.last_name + ' / ' + self.company.company_name
  end

end

