class AdminCost < ApplicationRecord
  belongs_to :account
  # validates :percent, numericality: {greater_than: 0}
end
