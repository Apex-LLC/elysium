class CreateRates < ActiveRecord::Migration[5.1]
  def change
    create_table :rates do |t|
      t.string :symbol
      t.float :rate
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
