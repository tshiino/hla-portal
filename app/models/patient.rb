class Patient < ActiveRecord::Base
  include Enumerize
  enumerize :affiliation, :in => [:Vietnam, :Ghana, :India, :Japan]
  enumerize :gender, :in => [:Unknown, :Male, :Female, :Other]
  enumerize :edu_background, :in => [:None, :PrimarySchool, :SecondarySchool, :HighSchool, :VocationalCollege, :Bachelor, :Master, :Doctor, :Others, :Unconfirmed]
  enumerize :marital_status, :in => [:Single, :Married, :Divorced, :Widowed, :Unfonfirmed]
  enumerize :risk, :in => [:MSM, :Heterosexual, :IVDU, :Bisexual, :MTC, :Hemophilia, :Transfusion, :Unidentified]

end
