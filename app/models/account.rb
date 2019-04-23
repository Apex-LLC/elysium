class Account < ApplicationRecord
  has_one :site
  has_many :users
  has_many :tenants
  has_many :rates
  has_many :admin_costs
  has_many :billable_meters

  def amount_overdue
    amount_overdue=0.0
    invoices.select{|i| i.status == "overdue"}.each do |invoice|
      amount_overdue += invoice.total
    end
    return amount_overdue
  end

  def amount_billed
    amount_billed=0.0
    invoices.select{|i| i.end_date.month == (DateTime.now.month + billing_cycle_start_day.days).prev_month.month}.each do |invoice|
      amount_billed += invoice.total
    end
    return amount_billed
  end

  def amount_due
    totalDue=0.0
    for tenant in self.tenants
      totalDue += tenant.amount_due
    end
    return totalDue
  end

  def amount_received
    totalReceived=0.0
    invoices.each do |invoice|
      if (invoice.status=="paid" && invoice.send_date.month == DateTime.now.month)
        totalReceived+=invoice.total
      end
    end
    return totalReceived
  end

  def invoices
    invoices=Array.new
    self.tenants.each do |t|
      (invoices << t.invoices).flatten!
    end
    return invoices.sort_by(&:end_date).reverse
  end

  def billing_cycles
    ordered_invoices = self.invoices
    return ordered_invoices.group_by{|i| i.readable_date }.map
  end

  def billing_cycle_span_description
    
  end

end
