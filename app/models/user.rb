class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tenants
  has_one :site

  def amount_billed
    amount_billed=0.0
    invoices.select{|i| i.end_date.month == DateTime.now.prev_month.month}.each do |invoice|
      amount_billed += invoice.amount
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
      if (invoice.status=="Paid" && invoice.send_date.month == DateTime.now.month)
        totalReceived=invoice.amount
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

  def billable_meters
    billable_meters=[]
    for tenant in self.tenants
      billable_meters << tenant.billable_meters.all
    end
    billable_meters = billable_meters.flatten
    return billable_meters
  end
end
