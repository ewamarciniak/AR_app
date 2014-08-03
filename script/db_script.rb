require 'yaml'
require 'securerandom'
require 'active_record'
require 'activerecord-import'
require 'logger'
require 'csv'
require './config/environment.rb'

DB_YML = "./config/database.yml"

RAILS_ENV = ENV['RAILS_ENV'] || "development"
db_config = {}
if File.exist?(DB_YML)
  settings = YAML.load_file(DB_YML)
  if settings and settings.include?(RAILS_ENV)
    db_config["database"] = settings[RAILS_ENV]
    puts db_config
  end
else
  raise "database.yml not found!"
end

# Establish connection to the DB based on the 'development'.
ActiveRecord::Base.establish_connection(db_config["database"])
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.transaction do

  address_inserts = []

  CSV.foreach("script/addresses.csv") do  |row|
    line1 = row[0].strip
    line2 = row[1] unless row[1]=='nil'
    postcode = row[2] unless row[2]=='nil'
    city = row[3]
    county = row[4]

    address_inserts << "('#{line1}', "+ (line2 ? "'#{line2}'" : "null") + ", " + (postcode ? "'#{postcode}'" : "null") +
        ", '#{city}', '#{county}', now(), now())"
  end

  unless address_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO addresses (line1, line2,\
postcode, city, county, created_at, updated_at) VALUES #{address_inserts.join(', ')}")
    #print "INSERT INTO addresses (line1, line2, postcode, city, county,created_at, updated_at) VALUES #{address_inserts.join(", ")}"
  end
  puts "________________________________________________________________________"
  puts "adresses done"
end

ActiveRecord::Base.transaction do

  companies_inserts = []
  address_ids = Address.pluck(:id)

  CSV.foreach("script/companies.csv") do  |row|
    company_name = row[0].strip
    fax_number = row[1] unless row[1]=='nil'
    phone_number = row[2] unless row[2]=='nil'
    reg_number = row[3]
    address_id = address_ids.pop

    companies_inserts << "('#{company_name}', '#{fax_number}','#{phone_number}',\
	'#{reg_number}', #{address_id}, now(), now())"
  end
  unless companies_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO companies (company_name, fax_number,\
		phone_number, reg_number, address_id, created_at, updated_at) VALUES #{companies_inserts.join(", ")}")
    #print "INSERT INTO companies (company_name, fax_number,phone_number, reg_number, address_id,\
    #created_at, updated_at) VALUES #{companies_inserts.join(", ")}"
  end
  puts "________________________________________________________________________"
  puts "companies done"

end

ActiveRecord::Base.transaction do
  company_ids = Company.pluck(:id)

  #now insert clients and people
  clients_inserts =[]
  people_c_inserts = []
  CSV.foreach("script/clients.csv") do  |row|
    method = row[4]
    hours = row[5]

    clients_inserts << "('#{method}', '#{hours}', now(), now())"
  end
  unless clients_inserts.empty?
      ActiveRecord::Base.connection.execute("INSERT INTO clients (pref_method_of_contact, \
			pref_hours_of_contact, created_at, updated_at) VALUES #{clients_inserts.join(", ")}")

      #print "INSERT INTO clients (pref_method_of_contact, pref_hours_of_contact, \
      #created_at, updated_at) VALUES #{clients_inserts.join(", ")}"
      profile_ids = Client.pluck(:id)

      CSV.foreach("script/clients.csv") do  |row|
        fns = row[0].strip
        lns = row[1]
        phone_number = row[2]
        email = row[3]
        company_id = company_ids.pop
        profile_id = profile_ids.pop

        people_c_inserts << "('#{fns}', '#{lns}', '#{phone_number}', '#{email}', #{company_id}, #{profile_id}, 'Client', now(), now())"
      end

      unless people_c_inserts.empty?
        ActiveRecord::Base.connection.execute("INSERT INTO people (first_name, last_name,\
		    phone_number, email, company_id, profile_id, profile_type, created_at, updated_at) VALUES #{people_c_inserts.join(", ")}")

        #print "INSERT INTO people (first_name, least_name,\
        #phone_number, email, company_id, profile_id, profile_type, created_at, updated_at) VALUES #{people_c_inserts.join(", ")}"

      end
  end

  puts "________________________________________________________________________"
  puts "clients done"
end

ActiveRecord::Base.transaction do
  #now insert team_members and people
  team_members_inserts =[]
  people_t_inserts = []

  CSV.foreach("script/team_members.csv") do  |row|
    team = row[4]
    exp = row[5]
    qual = row[6]
    lead = row[7]

    team_members_inserts << "('#{team}', '#{exp}', '#{qual}', '#{lead}', now(), now())"
  end

  unless team_members_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO team_members (team, experience_level, \
			qualification, lead, created_at, updated_at) VALUES #{team_members_inserts.join(", ")}")
    #print "INSERT INTO team_members (team, experience_level, qualification, lead, created_at, \
    #updated_at) VALUES #{team_members_inserts.join(", ")}"

    profile_ids = TeamMember.pluck(:id)
    used_comp_ids = Person.pluck(:company_id)
    comp_ids = Company.pluck(:id)
    company_ids = []
    comp_ids.each do |not_used|
      company_ids << not_used unless used_comp_ids.include?(not_used)
    end

    CSV.foreach("script/team_members.csv") do  |row|
      fns = row[0].strip
      lns = row[1]
      phone_number = row[2]
      email = row[3]
      company_id = company_ids[rand(0..(company_ids.size-1))]
      profile_id = profile_ids.pop

      people_t_inserts << "('#{fns}', '#{lns}', '#{phone_number}', '#{email}', #{company_id}, #{profile_id}, 'TeamMember', now(), now())"
    end
    unless people_t_inserts.empty?
      ActiveRecord::Base.connection.execute("INSERT INTO people (first_name, last_name,\
      phone_number, email, company_id, profile_id, profile_type, created_at, updated_at) VALUES #{people_t_inserts.join(", ")}")
      #print "INSERT INTO people (first_name, last_name,phone_number, email, company_id, profile_id, profile_type, created_at, updated_at)\
      #VALUES #{people_t_inserts.join(", ")}"
    end
  end

  puts "________________________________________________________________________"
  puts "team members done"
end

ActiveRecord::Base.transaction do
  #projects
  projects_inserts = []
  client_ids = Client.pluck(:id)
  CSV.foreach("script/projects.csv") do  |row|
    if client_ids.empty?
      puts "empty"
      client_ids = Client.pluck(:id)
    else
      puts "NNNNNNN"
      client_id = client_ids.pop
    end
    client_id = client_id || 1
    budget = row[0].strip
    delivery_deadline = row[1]
    status = row[2]

    projects_inserts << "(#{client_id},'#{budget}', '#{delivery_deadline}', '#{status}', now(), now())"
  end

  unless projects_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO projects (client_id, budget, delivery_deadline, status,\
		created_at, updated_at) VALUES #{projects_inserts.join(", ")}")
    #print "INSERT INTO projects (budget, delivery_deadline, status,created_at, updated_at) VALUES #{projects_inserts.join(", ")}"
  end

  puts "________________________________________________________________________"
  puts "projects done"
end
##project_team_members
#project_team_member_inserts=[]
#proj_ids = Project.pluck(:id)
#tm_ids = TeamMember.pluck(:id)
#
#tm_ids.each do |tm_id|
#	proj_id =  proj_ids[rand(0..(proj_ids.size-1))]
#	project_team_member_inserts << "(#{proj_id}, #{tm_id}, now(), now()"
#end

ActiveRecord::Base.transaction do
  #documents
  docs_inserts = []
  project_ids = Project.pluck(:id)

  CSV.foreach("script/documents.csv") do  |row|
    proj_id =  project_ids[rand(0..(project_ids.size-1))]
    doc_type = row[0].strip
    revision_number = row[1]

    docs_inserts << "(#{proj_id}, '#{doc_type}', '#{revision_number}', now(), now())"
  end

  unless docs_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO documents (project_id, doc_type, revision_number,\
		created_at, updated_at) VALUES #{docs_inserts.join(", ")}")
    #print "INSERT INTO documents (project_id, doc_type, revision_number, created_at, updated_at) VALUES #{docs_inserts.join(", ")}"
  end

  puts "________________________________________________________________________"
  puts "documents done"
end

ActiveRecord::Base.transaction do
  #legal contracts
  l_contract_inserts = []
  project_ids = Project.pluck(:id)

  CSV.foreach("script/legal_contracts.csv") do  |row|
    signed_on = row[0].strip
    revised_on = row[1]
    copy_stored = row[2]
    project_id = project_ids.pop

    l_contract_inserts << "(#{project_id}, '#{signed_on}', '#{revised_on}', '#{copy_stored}', now(), now())"
  end

  unless l_contract_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO legal_contracts (project_id, signed_on, revised_on, copy_stored,\
		created_at, updated_at) VALUES #{l_contract_inserts.join(", ")}")
    #print "INSERT INTO legal_contracts (project_id, signed_on, revised_on, copy_stored, created_at, updated_at) VALUES #{l_contract_inserts.join(", ")}"
  end

  puts "________________________________________________________________________"
  puts "contracts done"
end

ActiveRecord::Base.transaction do
  #assign team members to every project
  projects_teammembers_inserts = []

  num_of_tms = TeamMember.all.size
  projs = Project.pluck(:id)
  projs.each do |pr_id|
    num_of_team_members = {"400000" => 1, "500000" => 2, "600000" => 3, "700000" => 4, "800000" => 4, "900000" => 4,
                           "1000000" => 5, "2000000" => 7, "3000000" => 9}
    budget = Project.find(pr_id).budget.to_i
    budget = budget.to_s
  puts "_________________________#{num_of_team_members["#{budget}"]}"
    (num_of_team_members["#{budget}"] || 1).times do
      team_member_id = TeamMember.find(rand(1..(num_of_tms-1))).id
      projects_teammembers_inserts << "(#{pr_id}, #{team_member_id})"
    end
  end

  ActiveRecord::Base.connection.execute("INSERT INTO projects_team_members (project_id, team_member_id)\
 VALUES #{projects_teammembers_inserts.join(", ")}")
  #print "INSERT INTO projects_team_members (project_id, team_member_id) VALUES #{projects_team_members.join(", ")}"
  puts "________________________________________________________________________"
  puts "done"
end