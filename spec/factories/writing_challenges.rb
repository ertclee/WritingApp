FactoryGirl.define do
  factory :writing_challenge do
    sequence(:exercise) { |n| "Challenge #{n}" }
  end
end
