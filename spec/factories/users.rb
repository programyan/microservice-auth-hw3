FactoryBot.define do
  factory :user do
    sequence(:name) { |index| "User#{index}" }
    sequence(:email) { |index| "user##{index}@example.com" }
    password { 'MyPass' }
  end
end