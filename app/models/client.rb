class Client < ActiveRecord::Base
  has_many :projects
  attr_accessible :pref_hours_of_contact, :pref_method_of_contact
end
