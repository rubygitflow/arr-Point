class AddLockToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lock, :boolean, default: false
  end
end
