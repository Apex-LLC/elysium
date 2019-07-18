class CreateInvoiceMeters < ActiveRecord::Migration[5.1]
  def change
    create_table :invoice_meters do |t|
      t.string :reference
      t.float :usage
      t.float :rate
      t.decimal :amount_due, precision: 8, scale: 2
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
