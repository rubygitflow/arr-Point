class AddCoordinatesToCars < ActiveRecord::Migration[6.0]
  def up
    change_table :cars do |t|
      t.float :coordinates, array: true
    end
  end

  def down
    change_table :cars do |t|
      t.remove :coordinates
    end
  end
end
