class AddPaymentVerifiedToTenants < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :payments_verified, :boolean, default: false
  end
end
