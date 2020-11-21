class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ride, null: false, foreign_key: true
      t.string   :payment_confirmation
      t.decimal  :rate
      t.decimal  :tariff
      t.decimal  :price
      t.datetime :paid_up

      t.timestamps
    end

    add_index :payments, :payment_confirmation, unique: true
  end
end
