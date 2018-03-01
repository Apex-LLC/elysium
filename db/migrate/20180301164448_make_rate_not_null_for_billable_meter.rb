class MakeRateNotNullForBillableMeter < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:billable_meters, :rate_id, false, 1)
  end
end
