class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tenants
  has_one :site

  def amount_due
    totalDue=0.0
    for tenant in self.tenants
      totalDue += tenant.amount_due
    end
    return totalDue
  end

  def amount_received
    totalReceived=0.0
    for tenant in self.tenants
      for invoice in tenant.invoices
        if (invoice.status=="Paid" && invoice.send_date.month == DateTime.now.month)
          totalReceived=invoice.amount
        end
      end
    end
    return totalReceived
  end

  def billing_cycles
    invoices=Array.new
    self.tenants.each do |t|
      (invoices << t.invoices).flatten!
    end
    return invoices.group_by{|i| i.readable_date }.map
  end
end
