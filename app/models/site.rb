class Site < ApplicationRecord
  belongs_to :user
  has_many :meters
  has_many :spaces
end
