class AddDatatypeUnitToMeters < ActiveRecord::Migration[5.1]
  def change
    add_column :meters, :datatype, :string
    add_column :meters, :unit, :string
  end
end
