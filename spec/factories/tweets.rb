FactoryBot.define do
  factory :tweet do
    text {Faker::Lorem.sentence}
    image {Faker::Lorem.sentence}
    user_id {1}
  end
end
