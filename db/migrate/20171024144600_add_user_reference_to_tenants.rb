class AddUserReferenceToTenants < ActiveRecord::Migration[5.1]
  def change
    remove_reference :users, :tenant, foreign_key: true
    add_reference :tenants, :user, foreign_key: true
  end
end
