FactoryBot.define do
  factory :user do
    name { "satou" }
    email { "satou@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
