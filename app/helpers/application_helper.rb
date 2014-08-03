module ApplicationHelper

  def name(person)
    person.first_name + ' ' + person.last_name
  end
end
