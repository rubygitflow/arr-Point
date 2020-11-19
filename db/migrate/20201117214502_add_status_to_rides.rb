class AddStatusToRides < ActiveRecord::Migration[6.0]
  def up
    create_enum "status_type", %w[Scheduled Execution Completed Aborted Rejected]

    change_table :rides do |t|
      t.enum :status, as: "status_type", default: "Scheduled"
    end
  end

  def down
    change_table :rides do |t|
      t.remove :status
    end

    drop_enum "status_type"
  end
end
