class RemoveDecimalFromTenantFees < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenant_fees, :decimal
  end
end
