FactoryBot.define do
  factory :task do
    task { "ランニング" }
    goal { 10 }
    user
  end
end
