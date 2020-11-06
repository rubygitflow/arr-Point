FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  sequence :name do |n|
    "user#{n}"
  end

  factory :user do
    email
    name
    phone{ '+71234567890' }
    role { 'Driver' }
    password { '12345678' }
    password_confirmation { '12345678' }
    role_rules_accepted   { true }
  end
end
