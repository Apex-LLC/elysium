class RemoveStripeAttributesFromUser < ActiveRecord::Migration[5.1]
  def change
      remove_column :users, :provider
      remove_column :users, :access_code
      remove_column :users, :publishable_key
  end
end
