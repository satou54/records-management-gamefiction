FactoryBot.define do
  factory :user_level do
    level { 10 }
    total_experience_point { 900 }
    user
  end
end
