class AddWorkhorseToCars < ActiveRecord::Migration[6.0]
  def change
    add_column :cars, :workhorse, :boolean, default: false
  end
end
