class AddDescriptionToTenantFee < ActiveRecord::Migration[5.1]
  def change
    add_column :tenant_fees, :description, :string
  end
end
