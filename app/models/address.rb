class Address < ActiveRecord::Base
  attr_accessible :city, :county, :line1, :line2, :postcode
end
