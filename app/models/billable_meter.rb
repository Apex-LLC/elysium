class BillableMeter < ApplicationRecord
  belongs_to :meter
  belongs_to :tenant
  has_and_belongs_to_many :invoices
  before_save :set_percent_allocation

  def get_records(start_date,end_date)
    records=self.meter.records
    records= records.select{ |r| r[:datetime] >= start_date && r[:datetime] <= end_date }
    return records
  end

  def get_usage(start_date,end_date)
    records=get_records(start_date,end_date)
    total_usage=0
    records.each do |r|
      total_usage += r.value
    end
    return total_usage
  end

  def get_amount_due(start_date,end_date)
    total_usage = get_usage(start_date,end_date)      
    return total_usage*0.084
  end

  private
    def set_percent_allocation      
      self.percent_allocation = 100 if self.percent_allocation.blank?
    end
end
