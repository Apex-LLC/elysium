class AddIndexToRecords < ActiveRecord::Migration[5.1]
  def change
    add_index :records, :datetime
  end
end
