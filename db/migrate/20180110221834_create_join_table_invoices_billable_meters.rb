class CreateJoinTableInvoicesBillableMeters < ActiveRecord::Migration[5.1]

  def self.up
    create_table :billable_meters_invoices, :id => false do |t|
      t.integer :invoice_id
      t.integer :billable_meter_id
    end
  end

  def self.down
    drop_table :billable_meters_invoices
  end

end
