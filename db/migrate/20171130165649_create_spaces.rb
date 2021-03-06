class CreateSpaces < ActiveRecord::Migration[5.1]
  def change
    create_table :spaces do |t|
      t.string :name
      t.string :description
      t.references :site, foreign_key: true

      t.timestamps
    end
  end
end
