class UpdateSchedulesAddIndexRenameClock < ActiveRecord::Migration[8.0]
  def change
    rename_column :schedules, :clock_in_time, :clocked_in_at
    rename_column :schedules, :clock_out_time, :clocked_out_at

    add_index :schedules, [ :user_id, :created_at ], name: 'idx_user_id_and_created_at'
  end
end
