FactoryBot.define do
  factory :schedule do
    sequence(:id)
    sequence(:user_id)
    clocked_in_at { Time.now.utc }
    clocked_out_at { nil }
    duration_in_seconds { nil }
  end
end
