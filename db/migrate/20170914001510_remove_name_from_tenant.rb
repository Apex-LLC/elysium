class RemoveNameFromTenant < ActiveRecord::Migration[5.0]
  def change
    remove_column :tenants, :name
  end
end
