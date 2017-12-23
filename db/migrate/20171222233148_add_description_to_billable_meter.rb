class AddDescriptionToBillableMeter < ActiveRecord::Migration[5.1]
  def change
    add_column :billable_meters, :description, :string
  end
end
