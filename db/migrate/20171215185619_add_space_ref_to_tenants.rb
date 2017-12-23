class AddSpaceRefToTenants < ActiveRecord::Migration[5.1]
  def change
    add_reference :tenants, :space, foreign_key: true
  end
end
