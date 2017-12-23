class AddTenantRefToBillableMeters < ActiveRecord::Migration[5.0]
  def change
    add_reference :billable_meters, :tenant, foreign_key: true
  end
end
