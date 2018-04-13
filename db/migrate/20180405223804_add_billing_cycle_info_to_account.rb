class AddBillingCycleInfoToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :billing_cycle_start_day, :integer
    add_column :accounts, :days_until_invoice_due, :integer
  end
end
