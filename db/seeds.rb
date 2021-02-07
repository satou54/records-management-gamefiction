user = User.first

Task.create!(task: "test1", goal: 1, user_id: user.id)
