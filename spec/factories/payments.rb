FactoryBot.define do
  factory :payment do
    user
    ride
    rate { 2000 }
    tariff { 0.05 }
    price { 100 }
  end
end
