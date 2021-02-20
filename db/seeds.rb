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

UserLevel.create!(level: 1, total_experience_point: 10, user_id: user1.id)
UserLevel.create!(level: 1, total_experience_point: 10, user_id: user2.id)

puts "user_levelsテーブルにデータ投入完了"

Level.create!(level: 1, required_experience_point: 0)
Level.create!(level: 2, required_experience_point: 100)
Level.create!(level: 3, required_experience_point: 200)
Level.create!(level: 4, required_experience_point: 300)
Level.create!(level: 5, required_experience_point: 400)
Level.create!(level: 6, required_experience_point: 500)
Level.create!(level: 7, required_experience_point: 600)
Level.create!(level: 8, required_experience_point: 700)
Level.create!(level: 9, required_experience_point: 800)

Task.create!(task: "test1", goal: 1, user_id: user1.id)
Task.create!(task: "test2", goal: 10, user_id: user1.id)
Task.create!(task: "test3", goal: 10, user_id: user2.id)

task1 = Task.first
task2 = Task.second
task3 = Task.third

puts "tasksテーブルにデータ投入完了"

ActionRecord.create!(action_day: "2021-02-02", action: 10, 
                     action_experience_point: 5, 
                     task_id: task1.id, user_id: user1.id)

ActionRecord.create!(action_day: "2021-02-05", action: 20, 
                     action_experience_point: 10, 
                     task_id: task1.id, user_id: user1.id)

ActionRecord.create!(action_day: "2021-02-09", action: 30, 
                     action_experience_point: 15, 
                     task_id: task1.id, user_id: user1.id)

ActionRecord.create!(action_day: "2021-02-09", action: 35, 
                     action_experience_point: 15, 
                     task_id: task2.id, user_id: user1.id)

 ActionRecord.create!(action_day: "2021-02-09", action: 45, 
                     action_experience_point: 15, 
                     task_id: task3.id, user_id: user2.id)
puts "action_recordsテーブルにデータ投入完了"