class AddPeakDemandToBillableMeter < ActiveRecord::Migration[5.1]
  def change
    add_column :billable_meters, :is_peak_demand_meter, :boolean, default: false
  end
end
