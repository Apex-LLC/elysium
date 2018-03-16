class Rate < ApplicationRecord
  belongs_to :user
  validates :rate, numericality: {greater_than: 0}
end
