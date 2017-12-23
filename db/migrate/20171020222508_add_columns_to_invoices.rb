class AddColumnsToInvoices < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :start_date, :datetime
    add_column :invoices, :end_date, :datetime
    add_column :invoices, :send_date, :datetime
    add_column :invoices, :status, :string
  end
end
