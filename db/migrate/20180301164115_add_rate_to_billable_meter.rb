class AddRateToBillableMeter < ActiveRecord::Migration[5.1]
  def change
    add_reference :billable_meters, :rate, foreign_key: true
  end
end
