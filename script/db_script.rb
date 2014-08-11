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
##projects_team_members
#projects_team_member_inserts=[]
#proj_ids = Project.pluck(:id)
#tm_ids = TeamMember.pluck(:id)
#
#tm_ids.each do |tm_id|
#	proj_id =  proj_ids[rand(0..(proj_ids.size-1))]
#	projects_team_member_inserts << "(#{proj_id}, #{tm_id}, now(), now()"
#end
ActiveRecord::Base.transaction do
  #legal contracts
  l_contract_inserts = []
  project_ids = Project.pluck(:id)

  CSV.foreach("script/legal_contracts.csv") do  |row|
    signed_on = row[0].strip
    revised_on = row[1]
    copy_stored = row[2]
    project_id = project_ids.pop
    title = row[3]

    l_contract_inserts << "(#{project_id}, '#{title}', '#{signed_on}', '#{revised_on}', '#{copy_stored}', now(), now())"
  end

  unless l_contract_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO legal_contracts (project_id, title, signed_on, revised_on, copy_stored,\
		created_at, updated_at) VALUES #{l_contract_inserts.join(", ")}")
    #print "INSERT INTO legal_contracts (project_id, title, signed_on, revised_on, copy_stored, created_at, updated_at) VALUES #{l_contract_inserts.join(", ")}"
  end

  puts "________________________________________________________________________"
  puts "contracts done"
end

ActiveRecord::Base.transaction do
  #documents
  random_indexes=[76, 104, 67, 35, 94, 165, 80, 134, 77, 127, 68, 27, 38, 142, 61, 22, 85, 25, 28, 68, 78, 137, 169, 115, 52, 69, 38, 64, 168, 170, 1,
                  68, 117, 33, 48, 85, 192, 127, 162, 98, 176, 70, 66, 141, 131, 66, 168, 170, 139, 180, 51, 68, 135, 93, 153, 106, 84, 101, 176, 117,
                  12, 152, 159, 43, 53, 102, 183, 171, 65, 25, 183, 52, 119, 48, 163, 7, 125, 28, 102, 141, 165, 109, 192, 86, 73, 146, 66, 167, 148,
                  135, 165, 162, 7, 57, 116, 178, 83, 194, 147, 40, 110, 183, 119, 136, 93, 67, 143, 191, 82, 44, 12, 103, 141, 159, 66, 149, 128, 84,
                  39, 63, 30, 90, 199, 134, 62, 98, 148, 151, 184, 149, 140, 119, 108, 188, 3, 149, 78, 78, 5, 70, 180, 190, 7, 185, 53, 25, 64, 39, 36,
                  118, 147, 66, 144, 9, 61, 0, 163, 190, 3, 185, 192, 154, 145, 24, 159, 61, 101, 72, 103, 80, 121, 12, 24, 167, 50, 164, 167, 134, 166,
                  16, 162, 147, 95, 26, 34, 192, 66, 195, 20, 35, 152, 139, 104, 125, 146, 154, 38, 26, 152, 94, 166, 142, 119, 85, 180, 160, 108, 162,
                  48, 19, 148, 66, 40, 96, 16, 178, 0, 188, 9, 75, 63, 37, 11, 140, 123, 197, 77, 140, 185, 157, 57, 108, 160, 93, 163, 91, 114, 103, 19,
                  12, 41, 64, 35, 71, 190, 127, 191, 159, 147, 33, 175, 145, 138, 134, 62, 57, 136, 27, 144, 159, 169, 43, 132, 118, 80, 144, 11, 66, 195,
                  2, 68, 86, 39, 3, 189, 3, 69, 72, 194, 190, 45, 45, 190, 164, 106, 157, 137, 0, 43, 35, 1, 98, 78, 141, 93, 195, 115, 85, 3, 182, 10,
                  50, 24, 33, 127, 32, 61, 81, 98, 78, 143, 63, 92, 102, 157, 72, 67, 38, 195, 113, 41, 107, 113, 17, 154, 173, 172, 3, 127, 12, 92, 136,
                  50, 85, 25, 46, 115, 126, 67, 79, 69, 190, 160, 65, 142, 146, 43, 34, 87, 190, 162, 144, 18, 71, 88, 159, 20, 8, 142, 118, 30, 172, 112,
                  112, 65, 83, 35, 148, 192, 47, 174, 108, 78, 31, 8, 54, 133, 120, 81, 66, 20, 51, 81, 8, 0, 103, 37, 73, 162, 182, 193, 80, 41, 138, 90,
                  170, 20, 182, 134, 197, 190, 66, 148, 173, 192, 0, 192, 92, 125, 19, 3, 127, 79, 126, 112, 119, 126, 87, 176, 70, 89, 144, 155, 138, 1,
                  117, 36, 52, 170, 71, 0, 18, 86, 17, 20, 60, 160, 18, 187, 133, 52, 67, 4, 178, 86, 178, 123, 106, 71, 174, 6, 93, 118, 84, 44, 197, 21,
                  149, 87, 174, 110, 5, 143, 61, 198, 120, 57, 23, 151, 0, 14, 148, 191, 39, 11, 157, 93, 95, 195, 141, 156, 58, 6, 106, 27, 160, 6, 102,
                  34, 149, 138, 90, 72, 185, 143, 145, 91, 181, 148, 103, 144, 198, 171, 46, 127, 64, 165, 157, 46, 130, 187, 15, 26, 145, 94, 165, 10, 1,
                  110, 79, 78, 61, 160, 98, 124, 78, 174, 135, 52, 0, 145, 115, 25, 172, 75, 2, 82, 38, 12, 0, 55, 100, 147, 145, 147, 116, 10, 123, 122,
                  55, 94, 131, 123, 22, 168, 18, 157, 82, 32, 136, 140, 77, 112, 142, 73, 81, 95, 18, 80, 140, 34, 176, 85, 115, 153, 20, 135, 146, 136,
                  56, 82, 185, 146, 118, 9, 116, 55, 98, 74, 61, 157, 120, 45, 114, 125, 154, 168, 69, 187, 157, 87, 25, 190, 71, 144, 175, 154, 175, 91,
                  7, 71, 21, 29, 80, 94, 190, 32, 59, 180, 113, 56, 127, 138, 64, 16, 94, 39, 126, 55, 161, 29, 37, 142, 156, 94, 102, 165, 129, 144, 84,
                  107, 51, 162, 61, 189, 155, 157, 48, 23, 170, 156, 126, 132, 87, 138, 58, 44, 142, 187, 20, 39, 170, 0, 153, 176, 76, 7, 64, 2, 157, 154,
                  96, 112, 178, 51, 99, 178, 157, 96, 156, 83, 124, 179, 33, 142, 138, 34, 3, 163, 176, 170, 108, 125, 183, 165, 117, 124, 185, 133, 24, 70,
                  176, 87, 171, 125, 133, 124, 127, 171, 117, 134, 142, 107, 122, 20, 64, 120, 167, 87, 69, 155, 153, 112, 91, 92, 172, 176, 37, 43, 118, 81,
                  161, 193, 50, 94, 135, 86, 133, 76, 26, 165, 93, 51, 71, 49, 193, 178, 37, 60, 155, 152, 99, 6, 155, 39, 7, 81, 58, 31, 38, 193, 162, 186,
                  188, 34, 192, 96, 92, 155, 101, 198, 8, 164, 152, 43, 14, 33, 132, 183, 10, 54, 63, 50, 57, 69, 104, 190, 185, 150, 105, 81, 78, 37, 85, 18,
                  176, 127, 179, 31, 52, 172, 19, 131, 175, 197, 101, 134, 163, 108, 31, 118, 193, 1, 194, 110, 64, 134, 190, 189, 179, 144, 58, 179, 20, 184,
                  93, 69, 60, 35, 20, 170, 134, 65, 71, 83, 167, 14, 184, 105, 60, 130, 91, 111, 66, 61, 85, 128, 103, 129, 168, 189, 59, 65, 124, 96, 96, 111,
                  12, 194, 115, 136, 189, 162, 191, 178, 7, 187, 81, 3, 32, 98, 57, 181, 21, 189, 56, 93, 62, 95, 98, 198, 166, 6, 100, 173, 146, 56, 96, 80,
                  11, 158, 178, 10, 69, 69, 197, 91, 57, 1, 129, 165, 155, 78, 141, 121, 136, 152, 43, 170, 33, 182, 165, 105, 59, 26, 148, 157, 10, 39, 5, 190,
                  109, 186, 94, 150, 192, 64, 36, 148, 187, 121, 87, 90, 181, 164, 102, 16, 69, 157, 10, 19, 192, 68, 145, 117, 154, 151, 163, 20, 10, 52, 10,
                  28, 23, 140, 141, 59, 196, 25, 152, 18, 191, 195, 190, 151, 118, 172, 173, 132, 88, 143, 82, 51, 75, 142, 55, 62, 136, 145, 117, 114, 170, 66,
                  59, 164, 23, 49, 86, 51, 190, 3, 6, 191, 115, 88, 169, 161, 69, 104, 35]
  indexes = [10, 22, 34, 67, 43, 0, 20, 11, 54, 27]
  legal_contract_ids = LegalContract.pluck(:id)
  docs_inserts = []
  project_ids = Project.pluck(:id)
  index_num = 0
  CSV.foreach("script/documents.csv") do  |row|

    proj_id =  project_ids[random_indexes[index_num]]
    index_num += 1
    doc_type = row[0].strip
    doc_name = row[1]
    revision_number = row[2]
    revision_date = row[3]

    if index_num%100==0
      contract_id = legal_contract_ids[indexes.pop]
    else
      contract_id = "N/A"
    end

    docs_inserts << "(#{proj_id}, '#{contract_id}', '#{doc_type}', '#{doc_name}', '#{revision_number}', '#{revision_date}', now(), now())"
  end

  unless docs_inserts.empty?
    ActiveRecord::Base.connection.execute("INSERT INTO documents (project_id, contract_id, doc_type, doc_name, revision_number,\
		revision_date, created_at, updated_at) VALUES #{docs_inserts.join(", ")}")
    #print "INSERT INTO documents (project_id, doc_type, doc_name, revision_number, revision_date, created_at, updated_at) VALUES #{docs_inserts.join(", ")}"
  end

  puts "________________________________________________________________________"
  puts "documents done"
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