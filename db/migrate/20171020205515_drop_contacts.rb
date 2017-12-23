class DropContacts < ActiveRecord::Migration[5.0]
  def change
    drop_table :contacts
    add_column :tenants, :name, :string
    add_column :tenants, :phone, :string
    add_column :tenants, :email, :string
  end
end
