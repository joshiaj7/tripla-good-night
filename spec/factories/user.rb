FactoryBot.define do
  factory :user do
    sequence(:id)
    name { "John Doe" }
  end
end
