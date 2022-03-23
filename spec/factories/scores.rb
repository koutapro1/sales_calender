FactoryBot.define do
  factory :score do
    association :user
    sequence(:start_time) { Faker::Date.between(from: 2.years.ago, to:2.years.from_now) }
    score { ("#{rand(1..1000)}" + "00").to_i }
    memo { "テストメモ" }
  end
end
