class Sample < ActiveRecord::Base
  belongs_to :patient
  has_many :sequences, dependent: :destroy

  enum serostatus: %i( Unconfirmed HIV-1 HIV-2 Dual )

  validates :patient_id, presence: true
  validates :date_sample_taken, presence:true
  validates :art_status, inclusion: { in: [true, false] }
  validates :cd4_count, numericality: { :greater_than_or_equal_to => 0, :less_than => 10000 }
  validates :viral_load, numericality: { :greater_than_or_equal_to => 0, :less_than => 1000000000 }
  validates :remarks, length: { :maximum => 255, :too_long => "Maximum length is 255 letters!!" }
  validates :operator_id, presence: true

  def self.import(table)
    imported = 0
    invalid = 0
    existent = 0
    if find_by(patient_id: table["patient_id"], date_sample_taken: table["date_sample_taken"]).nil?
      sample = new
      sample.attributes = table
      if sample.valid?
        sample.save!
        imported += 1
      else
        invalid += 1
      end
    else
      existent += 1
    end
    return imported, invalid, existent
  end
end
