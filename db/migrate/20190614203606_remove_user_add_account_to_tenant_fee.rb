class RemoveUserAddAccountToTenantFee < ActiveRecord::Migration[5.1]
  def change
    add_reference :tenant_fees, :account, foreign_key: true
    remove_column :tenant_fees, :user_id
  end
end
