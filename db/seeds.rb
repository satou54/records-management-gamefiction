puts "テストデータ投入"

user = User.first

Task.create!(task: "test1", goal: 1, user_id: user.id)
Task.create!(task: "test2", goal: 10, user_id: user.id)

puts "tasksテーブルにデータ投入完了"

task = Task.first

ActionRecord.create!(action_day: "2021-02-02", action: 10, 
                     action_experience_point: 5, 
                     task_id: task.id, user_id: user.id)

ActionRecord.create!(action_day: "2021-02-05", action: 10, 
                     action_experience_point: 5, 
                     task_id: task.id, user_id: user.id)

ActionRecord.create!(action_day: "2021-02-09", action: 10, 
                     action_experience_point: 5, 
                     task_id: task.id, user_id: user.id)

puts "action_recordsテーブルにデータ投入完了"