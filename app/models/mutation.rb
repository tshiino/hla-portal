class Mutation < ActiveRecord::Base
  belongs_to :sequence

  validates :sequence_id, presence: true
  validates :gene, presence: true
  validates :wildtype, presence: true
  validates :locus, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 2000 }
  validates :mutated, presence: true
end
