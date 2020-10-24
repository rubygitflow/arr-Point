class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :name,   null: false, default: ""
      t.string  :phone,  null: false, default: ""
      t.boolean :admin,  null: false, default: false
      t.timestamps
    end
  end
end
