class RemoveBillableMetersReferenceFromMeters < ActiveRecord::Migration[5.1]
def change  
    remove_reference :meters, :billable_meter, foreign_key: true
    add_reference :billable_meters, :meter, foreign_key: true
  end
end
