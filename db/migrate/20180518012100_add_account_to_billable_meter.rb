class AddAccountToBillableMeter < ActiveRecord::Migration[5.1]
  def change
    add_reference :billable_meters, :account, foreign_key: true
  end
end
