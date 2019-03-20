class AddUsageToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :usage, :decimal, precision: 8, scale: 2
  end
end
