# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140731142853) do

  create_table "addresses", :force => true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "postcode"
    t.string   "city"
    t.string   "county"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "pref_method_of_contact"
    t.string   "pref_hours_of_contact"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "company_name"
    t.string   "reg_number"
    t.string   "phone_number"
    t.string   "fax_number"
    t.integer  "address_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "companies", ["address_id"], :name => "index_companies_on_address_id"

  create_table "documents", :force => true do |t|
    t.integer  "project_id"
    t.string   "type"
    t.integer  "revision_number"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "documents", ["project_id"], :name => "index_documents_on_project_id"

  create_table "legal_contracts", :force => true do |t|
    t.integer  "project_id"
    t.date     "signed_on"
    t.date     "revised_on"
    t.string   "copy_stored"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "legal_contracts", ["project_id"], :name => "index_legal_contracts_on_project_id"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.integer  "company_id"
    t.integer  "profile_id"
    t.string   "profile_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "people", ["company_id"], :name => "index_people_on_company_id"

  create_table "project_team_members", :id => false, :force => true do |t|
    t.integer  "project_id"
    t.integer  "team_member_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "project_team_members", ["project_id"], :name => "index_project_team_members_on_project_id"
  add_index "project_team_members", ["team_member_id"], :name => "index_project_team_members_on_team_member_id"

  create_table "projects", :force => true do |t|
    t.integer  "client_id"
    t.float    "budget"
    t.date     "delivery_deadline"
    t.string   "status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"

  create_table "team_members", :force => true do |t|
    t.string   "team"
    t.string   "experience_level"
    t.string   "qualification"
    t.boolean  "lead"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
