class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ride, null: false, foreign_key: true
      t.decimal :rate
      t.decimal :tariff
      t.decimal :price
      t.datetime :paid_up

      t.timestamps
    end
  end
end
