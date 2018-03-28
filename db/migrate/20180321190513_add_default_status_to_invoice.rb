class AddDefaultStatusToInvoice < ActiveRecord::Migration[5.1]
  def change
    change_column :invoices, :status, :string, :default => "Unpaid", :null => false
  end
end
