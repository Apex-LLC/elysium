class Rate < ApplicationRecord
  belongs_to :account
  has_many :billable_meters
  validates :rate, numericality: {greater_than: 0}

  def display_name 
    "#{self.symbol} ($" + "%.2f" % self.rate + ")"
  end
end
