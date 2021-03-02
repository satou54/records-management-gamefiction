FactoryBot.define do
  factory :action_record do
    action_day { "2021-02-06" }
    action { 1 }
    action_experience_point { 1 }
    user
    task
  end
end
