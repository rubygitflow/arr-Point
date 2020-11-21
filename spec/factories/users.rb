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

  # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#traits
  trait :not_an_admin do
    admin { false }
  end

  trait :admin do
    admin { true }
  end

  trait :as_driver do
    role { 'Driver' }
  end

  trait :as_passager do
    role { 'Passager' }
  end

  trait :unauthorized do
    authy_id { nil }
    last_sign_in_with_authy { nil }
    authy_enabled   { false }
    authy_hook_enabled   { true }
  end

  trait :authorized do
    authy_id { '1234' }
    last_sign_in_with_authy { '2020-11-09 06:05:33' }
    authy_enabled   { false }
    authy_hook_enabled   { false }
  end
end
