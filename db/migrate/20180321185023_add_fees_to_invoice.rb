class AddFeesToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :fees, :decimal, precision: 8, scale: 2
  end
end
