class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.integer :user_id, null: false
      t.datetime :clock_in_time
      t.datetime :clock_out_time
      t.integer :duration_in_seconds

      t.timestamps

      t.index [ :user_id ], name: 'idx_user_id'
    end
  end
end
