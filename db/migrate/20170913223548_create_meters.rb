class CreateMeters < ActiveRecord::Migration[5.0]
  def change
    create_table :meters do |t|
      t.string :name
      t.string :description
      t.string :reference
      t.datetime :last_collection

      t.timestamps
    end
  end
end
