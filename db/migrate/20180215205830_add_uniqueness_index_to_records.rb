class AddUniquenessIndexToRecords < ActiveRecord::Migration[5.1]
  def change
    add_index :records, [:datetime, :meter_id], :unique => true
  end
end
