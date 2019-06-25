class AddUserReferenceToTenantFees < ActiveRecord::Migration[5.1]
  def change
    add_reference :tenant_fees, :user, foreign_key: true
  end
end
