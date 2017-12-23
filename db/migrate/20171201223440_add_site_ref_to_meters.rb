class AddSiteRefToMeters < ActiveRecord::Migration[5.1]
  def change
    add_reference :meters, :site, foreign_key: true
    add_reference :billable_meters, :space, foreign_key: true
  end
end
