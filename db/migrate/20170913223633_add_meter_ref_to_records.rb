class AddMeterRefToRecords < ActiveRecord::Migration[5.0]
  def change
    add_reference :records, :meter, foreign_key: true
  end
end
