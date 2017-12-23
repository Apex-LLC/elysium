class AddTenantRefToInvoice < ActiveRecord::Migration[5.0]
  def change
    add_reference :invoices, :tenant, foreign_key: true
  end
end
