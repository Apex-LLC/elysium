class DropSites < ActiveRecord::Migration[5.1]
  def change
    drop_table :sites
  end
end
