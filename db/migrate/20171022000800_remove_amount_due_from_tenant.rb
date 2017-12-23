class RemoveAmountDueFromTenant < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenants, :amount_due
  end
end
