class CreateWatchlists < ActiveRecord::Migration[8.0]
  def change
    create_table :watchlists do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :watchlists, [ :follower_id, :followed_id ], unique: true, name: 'idx_follower_followed'
    add_index :watchlists, [ :follower_id, :followed_id, :active ], name: 'idx_follower_followed_active'
  end
end
