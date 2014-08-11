class Document < ActiveRecord::Base
  belongs_to :project
  attr_accessible :revision_number, :doc_type, :doc_name, :revision_date, :project_id, :contract_id
end
