class Account < ApplicationRecord
  has_one :site
  has_many :users
  has_many :tenants
  has_many :rates
  has_many :admin_costs
  has_many :billable_meters
  has_many :tenant_fees, dependent: :destroy

  def amount_overdue
    amount_overdue=0.0
    invoices.select{|i| i.status == "overdue"}.each do |invoice|
      amount_overdue += invoice.total
    end
    return amount_overdue
  end

  def amount_due
    total_due=0.0

    start_date = latest_billing_cycle_start_date

    invoices.select{|i| i.start_date == start_date}.each do |invoice|
      if (invoice.status!="paid")
        total_due+=invoice.total
      end
    end
    return total_due
  end

  def amount_received
    total_received=0.0

    start_date = latest_billing_cycle_start_date

    invoices.select{|i| i.start_date == start_date}.each do |invoice|
      if (invoice.status=="paid")
        total_received+=invoice.total
      end
    end
    return total_received
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

  private
    def latest_billing_cycle_start_date
      billingCycles = self.billing_cycles
      if (billingCycles != nil)
        return billingCycles.first[1].first.start_date
      else
        return DateTime.now.beginning_of_month
      end
    end
end
