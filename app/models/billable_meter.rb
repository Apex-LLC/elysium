class BillableMeter < ApplicationRecord

  belongs_to :meter
  belongs_to :tenant, optional: true
  belongs_to :account
  has_and_belongs_to_many :invoices
  belongs_to :rate
  before_save :set_percent_allocation

  def get_records(start_date,end_date)
    records=self.meter.records
    records= records.select{ |r| r[:datetime] >= start_date && r[:datetime] <= end_date }
    return records
  end

  def get_usage(start_date,end_date)
    records=get_records(start_date,end_date)
    total_usage=0

    if (records.count > 2)
      records = normalize_records(records)
      total_usage = get_total_usage(records)
    end

    return total_usage
  end

  def get_total_usage(records)
    total = 0.0

    start_index = records.count - 1

    #loop backwards until we hit 0
    start_index.downto(1) do |i|
      if records[i].value < records[i-1].value #a reset occurred!
        total += records[i].value
      else
        total += records[i].value - records[i-1].value
      end
    end

    return total

  end

  def normalize_records(records)
    a = records[0]
    b = records[0]
    c = records[0]
    d = records[0]

    records.each_with_index do |r,i|
      c = records[i]
      b = get_previous_record(c, records)

      if (c.value < b.value) #i        
        a = get_last_unique_record(b, records)

        if (a.value <= c.value) #ii
          b_index = records.index(b)
          records[b_index].value = (c.value + a.value) / 2.0
        else
          d = get_next_unique_record(c, records)
          if ((d.value - c.value).abs <  (c.value-b.value).abs) #iii
            #reset occurred!! this is accounted for in the usage calc
          elsif ((d.value - c.value).abs >  (c.value-b.value).abs) #iiii
            c_index = records.index(c)
            records[c_index].value = (d.value + b.value) / 2.0
          end
        end
      end
    end

    return records
  end

  def get_previous_record(c, records)
    current_index = records.index(c)
    if (current_index > 0)
      return records[current_index - 1]
    else
      return records[current_index]
    end
  end

  def get_last_unique_record(b, records)
    start_index = records.index(b)
    start_value = records[start_index].value

    if (start_index > 0)
      #loop backwards until we hit 0 or until we find a unique val
      (start_index-1).downto(0) do |i|
        if records[i].value != start_value
          return records[i]
        end
      end
    end 

    return b  
  end

  def get_next_unique_record(c, records)
    start_index = records.index(c)
    start_value = records[start_index].value
    last_record_index = records.count - 1

    if (start_index < last_record_index)
      #loop forwards until we hit the end or until we find a unique val
      for i in (start_index+1)..last_record_index
        if records[i].value != start_value
          return records[i]
        end
      end
    end 

    return c
  end

  def get_peak_demand(start_date, end_date)
    records = get_records(start_date, end_date)
    if (records.count > 0)
      return records.max_by(&:value).value
    else
      return 0
    end
  end

  def get_amount_due(start_date,end_date)
    total_usage = 0.0
    if (self.is_peak_demand_meter?)
      total_usage = get_peak_demand(start_date, end_date)
    else
      total_usage = get_usage(start_date,end_date)
    end
    
    return total_usage*self.rate.rate
  end

  def graphable_data_hash(start_date, end_date)
    records = get_records(start_date, end_date)
    record_map = records.map{|r| [r.datetime,r.value.round(2)]}
    return Hash[record_map]
  end

  private
    def set_percent_allocation      
      self.percent_allocation = 100 if self.percent_allocation.blank?
    end
end
