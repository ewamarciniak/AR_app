class Company < ActiveRecord::Base
  belongs_to :address
  has_many :people
  attr_accessible :company_name, :fax_number, :phone_number, :reg_number, :address_id
  accepts_nested_attributes_for :address
end