class RemoveWhenFromRides < ActiveRecord::Migration[6.0]
  def change
    remove_column :rides, :when, :string
  end
end
