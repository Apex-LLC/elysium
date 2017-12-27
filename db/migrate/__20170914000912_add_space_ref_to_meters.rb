class AddSpaceRefToMeters < ActiveRecord::Migration[5.0]
  def change
    add_reference :meters, :space, foreign_key: true
  end
end
