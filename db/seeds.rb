puts "テストデータ削除"
User.destroy_all
Task.destroy_all
ActionRecord.destroy_all

puts "テストデータ投入"

User.create!(name: "test", email: "test@example.com", password: "password")
User.create!(name: "test2", email: "test2@example.com", password: "password")

puts "usersテーブルにデータ投入完了"

user1 = User.first
user2 = User.second

Task.create!(task: "test1", goal: 1, user_id: user1.id)
Task.create!(task: "test2", goal: 10, user_id: user1.id)
Task.create!(task: "test3", goal: 10, user_id: user2.id)

puts "tasksテーブルにデータ投入完了"

task1 = Task.first
task2 = Task.second
task3 = Task.third


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