class RemoveUsageFromInvoice < ActiveRecord::Migration[5.1]
  def change
    remove_column :invoices, :usage
  end
end
