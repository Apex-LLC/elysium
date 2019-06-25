class CreateTenantFees < ActiveRecord::Migration[5.1]
  def change
    create_table :tenant_fees do |t|
      t.references :tenant, foreign_key: true
      t.decimal :amount, :decimal, precision: 8, scale: 2
      t.boolean :recurring

      t.timestamps
    end
  end
end
