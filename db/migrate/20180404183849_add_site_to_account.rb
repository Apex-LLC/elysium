class AddSiteToAccount < ActiveRecord::Migration[5.1]
  def change
    remove_column :sites, :user_id
    add_reference :sites, :account, foreign_key: true
  end
end
