class Record < ApplicationRecord
  validates_uniqueness_of :datetime, :scope => [:meter_id]

  belongs_to :meter
end
