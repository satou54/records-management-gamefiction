puts "テストデータ削除"
User.destroy_all
Task.destroy_all
ActionRecord.destroy_all
UserLevel.destroy_all
Level.destroy_all

puts "テストデータ投入"

User.create!(name: "test", email: "test@example.com", password: "password")
User.create!(name: "test2", email: "test2@example.com", password: "password")

user1 = User.first
user2 = User.second

puts "usersテーブルにデータ投入完了"

UserLevel.create!(level: 1, total_experience_point: 0, user_id: user1.id)
UserLevel.create!(level: 1, total_experience_point: 0, user_id: user2.id)

puts "user_levelsテーブルにデータ投入完了"

level = 1
required_experience_point = 100

Level.create!(level: 1, required_experience_point: 0)
100.times do
  required_experience_point = level * 100
  level += 1
  Level.create!(level: level, required_experience_point: required_experience_point)
end


Task.create!(task: "ランニング", goal: 5, unit: "km", user_id: user1.id)
Task.create!(task: "スクワット", goal: 100, unit: "回", user_id: user1.id)
Task.create!(task: "瞑想", goal: 1.1, unit: "時間", user_id: user2.id)

task1 = Task.first
task2 = Task.second
task3 = Task.third

puts "tasksテーブルにデータ投入完了"

ActionRecord.create!(action_day: "2021-02-02", action: 1, 
                     action_experience_point: 20, 
                     task_id: task1.id, user_id: user1.id)

ActionRecord.create!(action_day: "2021-02-05", action: 2, 
                     action_experience_point: 40, 
                     task_id: task1.id, user_id: user1.id)

ActionRecord.create!(action_day: "2021-02-09", action: 5, 
                     action_experience_point: 100, 
                     task_id: task1.id, user_id: user1.id)

ActionRecord.create!(action_day: "2021-02-09", action: 35, 
                     action_experience_point: 35, 
                     task_id: task2.id, user_id: user1.id)

 ActionRecord.create!(action_day: "2021-02-09", action: 0.2, 
                     action_experience_point: 18, 
                     task_id: task3.id, user_id: user2.id)

puts "action_recordsテーブルにデータ投入完了"