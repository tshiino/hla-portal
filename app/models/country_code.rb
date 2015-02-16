class CountryCode < ActiveRecord::Base
  has_many  :patients
end
