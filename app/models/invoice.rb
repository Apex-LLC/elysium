
class Invoice < ApplicationRecord
  belongs_to :tenant
  has_and_belongs_to_many :billable_meters
  has_one :payment

  before_save :set_totals
  validates :billable_meters, :length => { :minimum => 1 }
  validates_associated :billable_meters

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

  def set_paid
    self.status = "Paid"
    self.save
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

end
