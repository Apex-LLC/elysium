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
    records = records.sort_by{|r| r.datetime}

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

  def get_amount_due_peak_demand(start_date,end_date)
    total_usage = get_peak_demand(start_date, end_date)
    
    return get_amount_due_from_usage(total_usage)
  end

  def get_amount_due_from_usage(usage)
    return usage*self.rate.rate
  end

  def graphable_data_hash(start_date, end_date)
    records = get_records(start_date, end_date)    
    record_map = records.group_by_day { |r| r.datetime }.map { |day, records| [day, find_usage_from_records(records)] }
    return Hash[record_map]
  end

  private
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
        b=c #b should always be previous record to c
        c = records[i]

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


    def find_usage_from_records(records)
      if (records.count == 0)
       return 0 
      end

      return records.last.value - records.first.value
    end

    def set_percent_allocation      
      self.percent_allocation = 100 if self.percent_allocation.blank?
    end
end
