class DropSpaces < ActiveRecord::Migration[5.1]
  def change
    drop_table :spaces
  end
end
