FactoryBot.define do
  factory :task do
    task { "ランニング" }
    goal { 10 }
    unit { "km" }
    user
  end
end
