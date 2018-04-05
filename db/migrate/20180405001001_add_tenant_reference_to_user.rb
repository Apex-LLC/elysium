class AddTenantReferenceToUser < ActiveRecord::Migration[5.1]
    def self.up
    create_table :tenants_users, :id => false do |t|
      t.integer :user_id
      t.integer :tenant_id
    end
  end

  def self.down
    drop_table :tenants_users
  end
end
