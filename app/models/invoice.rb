
class Invoice < ApplicationRecord
  belongs_to :tenant
  has_and_belongs_to_many :billable_meters
  has_one :payment, dependent: :destroy

  before_save :set_totals
  # validates :billable_meters, :length => { :minimum => 1 }
  validates_associated :billable_meters, :message=> lambda{|class_obj, obj| obj[:value].errors.full_messages.join(",") }
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
    if self.start_date.day == 1 && self.end_date.to_date == self.start_date.end_of_month.to_date
      return readable_date_single_month
    else
      return readable_date_with_dates
    end
  end  

  def set_usage
    usage=0.0
    self.billable_meters.each do |meter|
      usage+=meter.get_usage(self.start_date,self.end_date)
    end
    self.update_attribute(:usage, usage)

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
      total_usage = 0.0
      self.billable_meters.each do |meter|
        meter_usage = meter.get_usage(self.start_date,self.end_date)
        total_usage += meter_usage
        if (meter.is_peak_demand_meter?)
          total_due += meter.get_amount_due_peak_demand(self.start_date,self.end_date)
        else
          total_due += meter.get_amount_due_from_usage(meter_usage)
        end
      end
      self.usage = total_usage
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

    def readable_date_single_month
      month = Date::MONTHNAMES[self.start_date.month]
      year = self.start_date.year.to_s
      return month + " " + year
    end

    def readable_date_with_dates
      formatted_start_date=self.start_date.strftime("%B #{self.start_date.day.ordinalize}")
      formatted_end_date=self.end_date.strftime("%B #{self.end_date.day.ordinalize}")
      year = self.start_date.year.to_s
      return formatted_start_date + " - " + formatted_end_date + ", " + year
    end

end
