class AddStripeAccountIdToAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :stripe_account_id, :string
  end
end
