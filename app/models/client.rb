class Client < ActiveRecord::Base
  has_many :projects
  has_one :person, as: :profile, dependent: :destroy
  attr_accessible :person_attributes, :pref_hours_of_contact, :pref_method_of_contact
  accepts_nested_attributes_for :person

  def person_name
    person.name_and_company
  end
end
