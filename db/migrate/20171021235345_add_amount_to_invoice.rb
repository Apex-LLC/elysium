class AddAmountToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :amount, :decimal, precision: 8, scale: 2
  end
end
