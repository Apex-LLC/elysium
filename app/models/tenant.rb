class Tenant < ApplicationRecord
  has_many :invoices
  has_many :billable_meters
  has_many :payments
  belongs_to :user
  validates :name, :email, :user_id, presence: true

  def amount_due
    unpaid_invoices=self.invoices.where.not(status:"Paid")
    total_due=0.0
    for invoice in unpaid_invoices
       total_due+=invoice.amount 
    end
    return total_due
  end
end
