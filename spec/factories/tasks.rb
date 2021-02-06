FactoryBot.define do
  factory :task do
    task { "MyString" }
    goal { 1 }
    user { nil }
  end
end
