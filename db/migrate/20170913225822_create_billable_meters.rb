class CreateBillableMeters < ActiveRecord::Migration[5.0]
  def change
    create_table :billable_meters do |t|
      t.integer :percent_allocation
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end

     add_reference :billable_meters, :meter, foreign_key: true

  end

end
