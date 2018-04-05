class Tenant < ApplicationRecord
  has_many :invoices
  has_many :billable_meters
  has_many :payments
  belongs_to :account
  validates :name, :email, :account_id, presence: true
  validates :email, :uniqueness => { :case_sensitive => false }

  has_attached_file :logo, styles: { medium: "300x300>"}, default_url: "logo.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  def amount_due
    unpaid_invoices=self.invoices.where.not(status:"Paid")
    total_due=0.0
    for invoice in unpaid_invoices
       total_due+=invoice.total 
    end
    return total_due
  end
end
