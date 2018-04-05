class CreateAdminCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_costs do |t|
      t.string :label
      t.string :description
      t.float :percent
      t.float :flat_fee
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
