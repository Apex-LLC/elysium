class RemoveTenantsIdFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :tenants_id
  end
end
