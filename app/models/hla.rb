class Hla < ActiveRecord::Base
  belongs_to :patient

  validates :type, presence: true, inclusion: { in: %w(LocusA LocusB LocusC) }
  validates :patient_id, presence: true
  VALID_SEROTYPE_REGEX = /\d\d/i
  validates :serotype, presence: true, length: { is: 2 }, format: { with: VALID_SEROTYPE_REGEX }
#  VALID_ALLELE_REGEX = /\d\d(\/\d\d){0,2}/i
#  validates :allele, format: { with: VALID_ALLELE_REGEX }
  validates :homo, inclusion: { in: [true, false] }
  validates :operator_id, presence: true, numericality: { only_integer: true }

end
