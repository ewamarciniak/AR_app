module CompaniesHelper
  def team_members_present?(company)
    Person.where(:company_id => company.id).empty? ? false : true
  end
end
