class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.references :user, null: false, foreign_key: true, unique: true
      t.string :license_plate,     null: false
      t.string :model,             null: false
      t.integer :year_manufacture, null: false

      t.timestamps
    end
  end
end
