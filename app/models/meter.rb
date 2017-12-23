class Meter < ApplicationRecord
  has_many :records, dependent: :destroy
  belongs_to :site
end
