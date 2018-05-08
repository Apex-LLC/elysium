class Site < ApplicationRecord
  belongs_to :account
  has_many :meters
  has_many :spaces
end
