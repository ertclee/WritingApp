FactoryGirl.define do
  factory :user do
    name 'User'
    sequence(:email) { |n| "user-#{n}@example.com" }
  end
end
