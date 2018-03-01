class AddUniquenessIndexToMeters < ActiveRecord::Migration[5.1]
  def change
    add_index :meters, [:reference, :site_id], :unique => true
  end
end
