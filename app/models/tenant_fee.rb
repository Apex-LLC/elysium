class TenantFee < ApplicationRecord
  belongs_to :tenant
  belongs_to :account

  validates :amount, :description, presence: true
end
