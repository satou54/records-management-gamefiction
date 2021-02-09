puts "テストデータ削除"
User.destroy_all
Task.destroy_all
ActionRecord.destroy_all

puts "テストデータ投入"

User.create!(email: "test@example.com", password: "password")

puts "usersテーブルにデータ投入完了"

user = User.first

Task.create!(task: "test1", goal: 1, user_id: user.id)
Task.create!(task: "test2", goal: 10, user_id: user.id)

puts "tasksテーブルにデータ投入完了"

task = Task.first

ActionRecord.create!(action_day: "2021-02-02", action: 10, 
                     action_experience_point: 5, 
                     task_id: task.id, user_id: user.id)

ActionRecord.create!(action_day: "2021-02-05", action: 20, 
                     action_experience_point: 10, 
                     task_id: task.id, user_id: user.id)

ActionRecord.create!(action_day: "2021-02-09", action: 30, 
                     action_experience_point: 15, 
                     task_id: task.id, user_id: user.id)

puts "action_recordsテーブルにデータ投入完了"