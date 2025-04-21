10.times do
  user_id = rand(2..4)
  clocked_in_at = Faker::Time.between(from: 7.days.ago, to: 1.day.ago)
  clocked_out_at = clocked_in_at + rand(1..8).hours + rand(0..59).minutes
  duration_in_seconds = (clocked_out_at - clocked_in_at).to_i

  Schedule.create!(
    user_id: user_id,
    clocked_in_at: clocked_in_at,
    clocked_out_at: clocked_out_at,
    duration_in_seconds: duration_in_seconds,
    created_at: clocked_in_at,
    updated_at: clocked_out_at
  )
end
