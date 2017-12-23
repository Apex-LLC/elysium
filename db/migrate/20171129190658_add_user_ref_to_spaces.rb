class AddUserRefToSpaces < ActiveRecord::Migration[5.1]
  def change
    add_reference :spaces, :User, foreign_key: true
  end
end
