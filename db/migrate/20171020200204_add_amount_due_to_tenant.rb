class AddAmountDueToTenant < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :amount_due, :float
  end
end
