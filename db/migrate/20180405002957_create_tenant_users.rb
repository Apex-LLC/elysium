class CreateTenantUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :tenant_users, id: false do |t|
      t.references :tenant, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
