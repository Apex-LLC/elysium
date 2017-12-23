class RemoveMeterReferenceFromBillableMeter < ActiveRecord::Migration[5.0]
  def change
    remove_reference :billable_meters, :meter, foreign_key: true
    add_reference :meters, :billable_meter, foreign_key: true
  end
end
