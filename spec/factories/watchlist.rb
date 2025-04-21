FactoryBot.define do
  factory :watchlist do
    sequence(:id)
    follower_id { 1 }
    followed_id { 2 }
    active { true }
  end
end
