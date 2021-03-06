# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |n|
  User.create!(
    name: "テストユーザー#{n + 1}",
    email: "test#{n + 1}@example.com",
    password: 'password',
    password_confirmation: 'password'
  )
end

User.all.each do |user|
  30.times do
    Score.create!(
      start_time: Faker::Date.unique.between(from: 1.year.ago, to: 1.year.from_now),
      score: (rand(1..1000).to_s + '00').to_i,
      user: user
    )
  end
end
