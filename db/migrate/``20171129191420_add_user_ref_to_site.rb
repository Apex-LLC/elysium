class AddUserRefToSite < ActiveRecord::Migration[5.1]
  def change
    add_reference :spaces, :site, foreign_key: true
    remove_reference :spaces, :user, foreign_key: true
  end
end
