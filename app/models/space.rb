class Space < ApplicationRecord
  belongs_to :site
  has_many :meters
  has_one :tenant
end
