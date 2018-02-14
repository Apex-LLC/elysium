class Record < ApplicationRecord
  validates_uniqueness_of :value, :scope => [:datetime,:meter_id]

  belongs_to :meter
end
