
class Invoice < ApplicationRecord
  belongs_to :tenant
  has_and_belongs_to_many :billable_meters
  has_one :payment

  before_save :set_totals
  # validates :billable_meters, :length => { :minimum => 1 }
  validates_associated :billable_meters
  after_initialize :set_default_status, :if => :new_record?

  enum status: [:paid, :unpaid, :overdue]

  def graphable_data
    return self.billable_meters.map { |meter|
      {  
        name:meter.description,
        data:meter.graphable_data_hash(self.start_date, self.end_date)
      }
    }
  end

  def readable_date
    formatted_start_date=self.start_date.strftime("%B #{self.start_date.day.ordinalize}")
    formatted_end_date=self.end_date.strftime("%B #{self.end_date.day.ordinalize}")
    year = self.start_date.year.to_s
    return formatted_start_date + " - " + formatted_end_date + ", " + year
  end

  def usage
    usage=0.0
    self.billable_meters.each do |meter|
      usage+=meter.get_usage(self.start_date,self.end_date)
    end
    return usage
  end

  def total
    if (self.amount == nil)
      set_totals
    end

    admin_costs = get_admin_costs

    return self.amount + self.fees + admin_costs
  end

  def set_paid
    self.paid!
  end

  def overdue
    overdue = (DateTime.now > self.due_date && !self.paid?)
    if overdue
      self.overdue!
    end
    return overdue
  end

  private 
    def set_totals
      total_due=0.0
      self.billable_meters.each do |meter|
        total_due+=meter.get_amount_due(self.start_date,self.end_date)
      end
      self.amount=total_due
      self.fees = self.amount * ApplicationController.helpers.get_tax_fee_rate
    end

    def get_admin_costs
      admin_costs = 0.0
      self.tenant.account.admin_costs.each do |cost|
        if (cost.percent)
          admin_costs += self.amount * (cost.percent/100.0)
        else
          admin_costs += cost.flat_fee
        end
      end
      return admin_costs
    end

    def set_default_status
      self.status ||= :unpaid
    end

end
