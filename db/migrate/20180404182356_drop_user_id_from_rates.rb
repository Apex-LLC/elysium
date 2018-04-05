class DropUserIdFromRates < ActiveRecord::Migration[5.1]
  def change
    remove_column :rates, :user_id
  end
end
