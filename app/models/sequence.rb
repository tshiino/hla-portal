class Sequence < ActiveRecord::Base
  belongs_to :sample
  has_many :mutations, :dependent => :delete_all

  VALID_INS_REGEX = /\A(\d+-\d+)?(,\d+-\d+)*/
  validates :sample_id, presence: true
  validates :read, presence: true
  validates :gene, presence: true
  validates :start, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 10000 }
  validates :end, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 10000 }
  validates :sequence, presence: true
  validates :insertion, format: { with: VALID_INS_REGEX }
  validates :clonal, inclusion: { in: [true, false] }
  validates :provirus, inclusion: { in: [true, false] }
  validates :operator_id, presence: true
end
