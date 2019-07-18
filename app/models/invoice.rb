
class Invoice < ApplicationRecord
  belongs_to :tenant
  has_and_belongs_to_many :billable_meters
  has_one :payment, dependent: :destroy

  has_many :invoice_meters, dependent: :destroy

  before_save :set_totals, :if => :new_record?

  validates_associated :billable_meters, :message=> lambda{|class_obj, obj| obj[:value].errors.full_messages.join(",") }
  after_initialize :set_default_status, :if => :new_record?

  serialize :graphable_data, Array

  enum status: [:paid, :unpaid, :overdue, :completed]

  def readable_date
    if self.start_date.day == 1 && self.end_date.to_date == self.start_date.end_of_month.to_date
      return readable_date_single_month
    else
      return readable_date_with_dates
    end
  end  

  def total
    return self.amount + self.fees
  end

  def set_paid
    self.paid!
  end

  def overdue
    overdue = (DateTime.now > self.due_date && !self.paid? && !self.completed?)
    if overdue != self.overdue?
      self.overdue!
    end
    return overdue
  end

  private 
    def set_totals
      total_due=0.0

      self.billable_meters.each do |meter|

        meter_usage = meter.get_usage(self.start_date,self.end_date)        
        meter_amount_due = get_billable_meter_amount_due(meter, meter_usage)
        meter_reference = get_billable_meter_reference(meter)

        self.invoice_meters << InvoiceMeter.new(reference: meter_reference, usage: meter_usage, rate: meter.rate.rate, amount_due: meter_amount_due)
        total_due += meter_amount_due
      end

      generate_graphable_data

      self.amount=total_due
      self.fees = self.amount * ApplicationController.helpers.get_tax_fee_rate



      if (self.amount == 0.0)
        self.status = :completed
      end
    end

    def get_billable_meter_amount_due(meter, meter_usage)
      if (meter.is_peak_demand_meter?)
        meter_amount_due = meter.get_amount_due_peak_demand(self.start_date,self.end_date)
      else
        meter_amount_due = meter.get_amount_due_from_usage(meter_usage)
      end

      return meter_amount_due.round(2)
    end

    def get_billable_meter_reference(meter)
      if (meter.description?) 
        meter_reference = meter.description 
      else 
        meter_reference = meter.meter.reference 
      end 

      meter_reference = meter_reference + " (" + meter.rate.symbol + ")"

      return meter_reference
    end

    def generate_graphable_data
      data = self.billable_meters.map { |meter|
        {  
          name:meter.description,
          data:meter.graphable_data_hash(self.start_date, self.end_date)
        }
      }

      self.graphable_data = data
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
