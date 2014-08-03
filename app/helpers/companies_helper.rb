module CompaniesHelper
  def team_members_present?(company)
    Person.where(:company_id => company.id, :profile_type => "TeamMember").any?
  end

  def is_client?(company)
    Person.where(:company_id => company.id, :profile_type => "Client").any?
  end

  def company_client(company_id)
    pid = Person.find_by_company_id(company_id).profile_id
    client = Client.find(pid)
    return client
  end
end
