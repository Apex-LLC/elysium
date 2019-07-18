class AddGraphableDataToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_column :invoices, :graphable_data, :text
  end
end
