class AddStatusToInvoice < ActiveRecord::Migration[5.1]
  def change
    remove_column :invoices, :status, :string
    add_column :invoices, :status, :integer
  end
end
