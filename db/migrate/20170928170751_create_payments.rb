class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.datetime :date
      t.decimal :amount, precision:8, scale:2 
      t.references :tenant, foreign_key: true

      t.timestamps
    end
  end
end
