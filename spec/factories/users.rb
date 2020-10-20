FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: Random.new.rand(1..30)) }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password(min_length: 6, max_length: 32, mix_case: true, special_characters: true) }
    sequence(:id) {|n| n.to_s }
  end
end
