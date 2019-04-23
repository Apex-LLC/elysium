class Tenant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :billable_meters, dependent: :destroy
  has_many :payments
  has_many :tenant_users, 
  has_many :users, through: :tenant_users, dependent: :destroy
  belongs_to :account


  validates :name, :email, :account_id, presence: true
  validates :email, :uniqueness => { :case_sensitive => false }

  has_attached_file :logo, styles: { medium: "300x300>"}, default_url: "logo.png", storage: :s3


  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  def amount_due
    unpaid_invoices=self.invoices.where.not(status: :paid)
    total_due=0.0
    for invoice in unpaid_invoices
       total_due+=invoice.total 
    end
    return total_due
  end

  def invoice_due
    last_run_more_than_a_month_ago = last_invoice_end_date <= Date.today.last_month
    data_exists_for_current_period = true

    if (last_run_more_than_a_month_ago && data_exists_for_current_period)
      return true
    end

    return false
  end

  def last_invoice_end_date
    last_invoice = self.invoices.last

    if (last_invoice != nil)
      return last_invoice.end_date
    end

    return DateTime.new
  end

end
