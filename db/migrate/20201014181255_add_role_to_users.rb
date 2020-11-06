class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def up
    create_enum "role_type", %w[Driver Passenger]

    change_table :users do |t|
      t.enum :role, as: "role_type", default: "Driver"
    end
  end

  def down
    change_table :users do |t|
      t.remove :role
    end

    drop_enum "role_type"
  end
end
