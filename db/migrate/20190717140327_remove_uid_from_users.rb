class RemoveUidFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :uid
  end
end
