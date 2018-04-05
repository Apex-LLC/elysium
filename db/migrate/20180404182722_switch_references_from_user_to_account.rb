class SwitchReferencesFromUserToAccount < ActiveRecord::Migration[5.1]
  def change
    add_reference :rates, :account, foreign_key: true

    remove_column :tenants, :user_id
    add_reference :tenants, :account, foreign_key: true

    add_reference :users, :account, foreign_key: true
  end
end
