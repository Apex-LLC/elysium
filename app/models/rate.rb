class Rate < ApplicationRecord
  belongs_to :account
  validates :rate, numericality: {greater_than: 0}
end
