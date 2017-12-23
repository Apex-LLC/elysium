class ChangeColumnNamesToLower < ActiveRecord::Migration[5.0]
  def change
        rename_column :invoices, :Number, :number
        rename_column :records, :DateTime, :datetime
        rename_column :records, :Value, :value
        rename_column :tenants, :Name, :name
  end
end
