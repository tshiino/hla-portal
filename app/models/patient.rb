class Patient < ActiveRecord::Base
  belongs_to  :country_code, foreign_key: "nationarity"
  belongs_to  :user, foreign_key: "operator_id"
  has_many :locus_as, dependent: :destroy
  has_many :locus_bs, dependent: :destroy
  has_many :locus_cs, dependent: :destroy
  has_many :samples, dependent: :destroy

  include Enumerize
  enumerize :affiliation, :in => [:Vietnam, :Ghana, :India, :Japan]
  enumerize :gender, :in => [:Unknown, :Male, :Female, :Other]
  enumerize :edu_background, :in => [:Unconfirmed, :None, :PrimarySchool, :SecondarySchool, :HighSchool, :VocationalCollege, :Bachelor, :Master, :Doctor, :Others]
  enumerize :marital_status, :in => [:Uncertain, :Single, :Married, :Divorced, :Widowed]
  enumerize :risk, :in => {Unidentified: 'Unidentified', MSM: 'MSM', Heterosexual: 'Heterosexual', IVDU: 'IVDU', Bisexual: 'Bisexual', MTC: 'MTC', Hemophilia: 'Hemophilia', Transfusion: 'Transfusion'}

# NIID ID is essential and unique.
  validates :niid_id, presence: true, uniqueness: true, length: { maximum: 16 }
# LAB ID must be unique.
  validates :lab_id, uniqueness: true, length: { maximum: 16 }
# Affiliation is essential and must be include in an enum-list.
  validates :affiliation, presence: true
  validates :affiliation, inclusion: { in: %w(Vietnam Ghana India Japan) }
# Max.length of Hospital ID is 16
  validates :hosp_id, length: { maximum: 16 }
# Gender must be include in an enum-list
  validates :gender, inclusion: { in: %w(Unknown Male Female Other) }
# Nationarity is integer less than 200
  validates :nationarity, numericality: { only_integer: true, less_than: 200 }
# Educational background must be include in an enum-list
  validates :edu_background, inclusion: { in: %w(None PrimarySchool SecondarySchool HighSchool VocationalCollege Bachelor Master Doctor Others Unconfirmed) }
# Max.length of Occupation is 128
  validates :occupation, length: { maximum: 128 }
# Max.length of Marital status is 16
  validates :marital_status, inclusion: { in: %w(Single Married Divorced Widowed Uncertain) }
# Max.length of Risk is 16
  validates :risk, inclusion: { in: %w(Unidentified MSM Heterosexual IVDU Bisexual MTC Hemophilia Transfusion) }

# Batch seeding
  def self.import(file, opid)
    imported = 0
    invalid = 0
    existent = 0

    open(file.path, mode = "r", perm = 0666) do |f|
      csv = CSV.new(f, :headers => :first_row)
      csv.each do |row|
        next if row.header_row?
        table = Hash[[row.headers, row.fields].transpose]
        if find_by(:niid_id => table["niid_id"]).nil?
          patient = Patient.new
          patient.niid_id = table["niid_id"]
          patient.lab_id = table["lab_id"]
          patient.affiliation = table["affiliation"]
          patient.hosp_id = table["hosp_id"]
          patient.date_of_birth = table["date_of_birth"]
          patient.date_diagnosed = table["date_diagnosed"]
          if table["gender"].present? then
            patient.gender = table["gender"]
          else
            patient.gender = "Unknown"
          end
          if table["nationality"].present? then
            patient.nationarity = table["nationality"]
          else
            patient.nationarity = "1"
          end
          if table["edu_background"].present? then
            patient.edu_background = table["edu_background"]
          else
            patient.edu_background = "Unconfirmed"
          end
          if table["marital_status"].present? then
            patient.marital_status = table["marital_status"]
          else
            patient.marital_status = "Uncertain"
          end
          if table["risk"].present? then
            patient.risk = table["risk"]
          else
            patient.risk = "Unidentified"
          end
          patient.operator_id = opid
#          patient.operator_id = current_user.id
          if patient.valid?
            patient.save!
            imported += 1
          else
            invalid += 1
          end
        else
          existent += 1
        end
      end
    end

    return imported, invalid, existent
  end

end
