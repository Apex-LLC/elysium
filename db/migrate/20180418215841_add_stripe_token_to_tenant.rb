class AddStripeTokenToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :stripe_token, :string
  end
end
