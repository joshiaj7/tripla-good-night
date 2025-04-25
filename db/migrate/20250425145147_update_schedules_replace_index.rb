class UpdateSchedulesReplaceIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :schedules, [ :user_id, :created_at ], name: 'idx_user_id_and_created_at'
    add_index :schedules, [ :user_id, :created_at, :duration_in_seconds ], name: 'idx_user_id_created_at_duration_in_seconds'
  end
end
