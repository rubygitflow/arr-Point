class CreateRides < ActiveRecord::Migration[6.0]
  def change
    create_table :rides do |t|
      t.references :car, null: false, foreign_key: true
      t.decimal :cost
      t.string  :arrival
      t.string  :departure
      t.string  :when

      t.timestamps
    end
  end
end
