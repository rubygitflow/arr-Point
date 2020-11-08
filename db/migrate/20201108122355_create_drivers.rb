class CreateDrivers < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :driver_id,     null: false
      t.string  :license_id
      t.string  :region,        null: false
      t.integer :start_driving, null: false

      t.timestamps
    end
  end
end
