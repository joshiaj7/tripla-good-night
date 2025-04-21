class User < ApplicationRecord
  has_many :active_watchlists, -> { where(active: true) }, class_name: "Watchlist", foreign_key: :follower_id
  has_many :followings, through: :active_watchlists, source: :followed
end
