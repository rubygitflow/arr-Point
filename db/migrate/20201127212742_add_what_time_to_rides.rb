class AddWhatTimeToRides < ActiveRecord::Migration[6.0]
  def change
    add_column :rides, :what_time, :string
  end
end
