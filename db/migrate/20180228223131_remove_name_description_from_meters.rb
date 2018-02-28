class RemoveNameDescriptionFromMeters < ActiveRecord::Migration[5.1]
  def change
    remove_column :meters, :name, :string
    remove_column :meters, :description, :string
  end
end
