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
#ActiveRecord::Base.logger = Logger.new(STDOUT)
#TRAVERSALS

#T1: Raw traversal speed************************************************************************************************
#Traverse the Person hierarchy. As each team_member is visited, visit each of its referenced unshared Projects. As each
# project is visited, perform a depth first search on its graph of documents. Return a count of the number of documents
# visited when done./NO DEPTH FIRST SEARCH

#Traversal T2: Traversal with updates***********************************************************************************
#Repeat Traversal T1, but update objects during the traversal. There are three types of update patterns in this
# traversal. In each, a single update to a document consists of swapping its (signed_on, revised_on) attributes. The three types of
# updates are:
#A)	Update one document per project.
#B)	Update every document as it is encountered.
#C)	Update each document in a project four times

def traversal_2a
  all_people = Person.where(:profile_type => "TeamMember")
  docs = 0
  all_people.each do |person|
    team_member = TeamMember.find(person.profile_id)
    team_member.projects.each do |project|
      doc_num = 0
      documents = Document.where(:project_id => project.id)
      documents.each do |doc|
        #visiting instead of returning the size
        docs+=1
        doc_num += 1
        if doc_num == 1
          type = doc.doc_type
          name = doc.doc_name
          doc.doc_type = name
          doc.doc_name = type
          doc.save!
        end
      end
    end
  end
  return docs
end

def traversal_2b
  all_people = Person.where(:profile_type => "TeamMember")
  docs = 0
  all_people.each do |person|
    team_member = TeamMember.find(person.profile_id)
    team_member.projects.each do |project|
      documents = Document.where(:project_id => project.id)
      documents.each do |doc|
        #visiting instead of returning the size
        docs+=1
        type = doc.doc_type
        name = doc.doc_name
        doc.doc_type = name
        doc.doc_name = type
        doc.save
      end
    end
  end
  return docs
end

def traversal_2c
  all_people = Person.where(:profile_type => "TeamMember")
  docs = 0
  all_people.each do |person|
    team_member = TeamMember.find(person.profile_id)
    team_member.projects.each do |project|
      documents = Document.where(:project_id => project.id)
      documents.each do |doc|
        #visiting instead of returning the size
        docs+=1
        type = doc.doc_type
        name = doc.doc_name
        doc.doc_type = name
        doc.doc_name = type
        4.times do
          doc.save!
        end
      end
    end
  end
  return docs
end


#Traversal T3: Traversal with indexed field updates*********************************************************************
#Repeat Traversal T2, except that now the update is on the date field, which is indexed. The specific update is to
# increment the date if it is odd, and decrement the date if it is even.
def traversal_3
  all_people = Person.where(:profile_type => "TeamMember")
  docs = 0
  all_people.each do |person|
    team_member = TeamMember.find(person.profile_id)
    team_member.projects.each do |project|
      documents = Document.where(:project_id => project.id)
      documents.each do |doc|
        #visiting instead of returning the size
        docs+=1

        day = doc.revision_date.mday
        if day.odd?
          doc.revision_date += 1
        elsif day.even?
          doc.revision_date -= 1
        end
        doc.save!
      end
    end
  end
  return docs

end

#Traversal T6: Sparse traversal speed***********************************************************************************
#Traverse the person hierarchy. As each team member is visited, visit each of its referenced unshared projects. As each
# project is visited, visit the root document Return a count of the number of documents visited when done.
def traversal_6

  all_people = Person.where(:profile_type => "TeamMember")
  docs = 0
  all_people.each do |person|
    team_member = TeamMember.find(person.profile_id)
    team_member.projects.uniq.each do |project|
      documents = Document.where(:project_id => project.id)
      documents.each do |doc|
        #visiting instead of returning the size
        docs += 1
      end
    end
  end
  return docs
end

#Traversals T8 and T9: Operations on Manual.
#Traversal T8***********************************************************************************************************
#Scans the address object, counting the number of occurrences of the character “I.”
def traversal_8
  num_occurances = 0
  Address.all.each do |address|
   full_ad = address.line1 + ' '  + (address.line2 || '') + ' '  + address.city + address.county
   occurance = full_ad.downcase.scan(/i/).size
   num_occurances += occurance
  end
  return num_occurances
end

#Traversal T9***********************************************************************************************************
#Checks to see if the first and last character in the address object are the same.
def traversal_9
  num_occurances = 0
  Address.all.each do |address|
    require 'debugger'
    num_occurances += 1 if address.city.downcase.split('').first == address.city.downcase.split('').last
  end
  return num_occurances
end

#QUERIES

#Query Q1: exact match lookup*******************************************************************************************
#Generate 10 random Document ids; for each generated lookup the document with that id. Return the number of documents
#processed when done.
def query_1
  document_ids = Document.pluck(:id)
  #index_num = [ 342, 876, 44, 299, 908, 112, 4, 77, 643, 999]
  index_num = [ 42, 76, 44, 90, 8, 12, 4, 77, 43, 99]
  all_ids = []
  index_num.each do |num|
    all_ids << document_ids[num]
  end
  processed_number = 0
  all_ids.each do |id|
    Document.find(id)
    processed_number+=1
  end
  return processed_number
end

#Queries Q2, Q3, and Q7.
#Query Q2***************************************************************************************************************
#Choose a range for dates that will contain the last 1% of the dates found in the database's Documents. Retrieve the
#Documents that satisfy this range predicate.
def query_2
  start_date = '2014-03-30'.to_date
  end_date = '2014-08-05'.to_date
  documents = Document.where( :revision_date => (start_date..end_date))

  return documents.size
end

#Query Q3***************************************************************************************************************
#Choose a range for dates that will contain the last 10% of the dates found in the database's Documents. Retrieve the
# Documents that satisfy this range predicate.
def query_3
  start_date = '2014-01-10'.to_date
  end_date = '2014-01-18'.to_date
  documents = Document.where( :revision_date => (start_date..end_date))
  return documents.size
end

#Query Q4: path lookup**************************************************************************************************
#Generate 100 random legal_contract titles. For each title generated, find all TeamMembers that use the project
#corresponding to the legal_contract. Also, count the total number of team_members that qualify.
def query_4
  all_contracts = LegalContract.all.sort
  indexes = [0,18,2,4,1,15,3,17,16,19]
  contracts =[]
  10.times do
    contracts << all_contracts[indexes.pop].id
  end

  team_members = TeamMember.joins(:projects => :legal_contract).where(legal_contracts: { id: contracts })
  return team_members.size
end

def query_4a
  team_members_num = 0
  LegalContract.find_each do |contract|
    projects_team_members = contract.project.team_members.find(:all)
    team_members_num += projects_team_members.size
  end
  return team_members_num
end

#Query Q5: single-level make********************************************************************************************
#Find all Team_members that use a project with a build date later than the build date of the team_member. Also, report
#the number of qualifying team_members found.
def query_5
  team_members = TeamMember.includes(:projects).where("team_members.created_at > projects.created_at" )
  return team_members.size
end

#Query Q7***************************************************************************************************************
#Scan all documents and return their ids

def query_7
  document_ids = Document.pluck(:id)
  return document_ids.size
end

#Query Q8: ad-hoc join**************************************************************************************************
#Find all pairs of Legal_contracts and documents where the legal_contract_id in the document matches the id of the
#legal_contract. Also, return a count of the number of such pairs encountered.

def query_8
  all_relevant_docs = Document.joins(project: [:legal_contract]).where("legal_contracts.id = documents.contract_id" )
  return all_relevant_docs.count
end
#STRUCTURAL MODIFICATIONS

#Structural Modification 1: Insert**************************************************************************************
#Create five new projects, which includes creating a number of new documents (100 in the small configuration, 1000 in
#the large, and five new legal_contract objects) and insert them into the database by installing references to these
# projects into 10 randomly team_member objects.
def modification_1_insert
  projects =[]
  5.times do |project|
    proj = Project.new(
        :budget             => 300000.0,
        :delivery_deadline  => '2015-02-12',
        :status             =>  "Planning"
    )
    projects << proj
  end
  Project.transaction do
    projects.each { |project | project.save!}
  end

  documents = []
  20.times do
    projects.each do |project|
      doc = Document.new(
          :project_id => project.id,
          :doc_type => "drawing",
          :doc_name => "The first floor plans",
          :revision_number => 3,
          :revision_date => '2014-07-12'
      )
      documents << doc
    end
  end
  Document.import documents

  contracts = []
  projects.each do |project|
    contract = LegalContract.new(
        :project_id => project.id,
        :title => "SLA",
        :signed_on => '2013-04-02',
        :revised_on => '2013-12-12',
        :copy_stored => 'electronic version'
    )
    contracts << contract
  end
  LegalContract.import contracts

  return projects.size
end

#Structural Modification 2: Delete**************************************************************************************
#Delete the five newly created projects (and all of their associated documents and legal_contract objects).
def modification_2_deletion
  projects = Project.find(:all, :order => "id desc", :limit => 5)
  projects.each do |project|
    Document.where(:project_id => project.id).destroy_all
    LegalContract.where(:project_id => project.id).destroy_all
    project.destroy
  end
 return "deleted"
end

Benchmark.bm do |x|

  x.report("ActiveRecord#query_8 \n") do
    puts query_8
  end

end