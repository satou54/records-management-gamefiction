json.set! :task do
  json.extract! @task, :id, :task, :goal, :user_id, :created_at, :updated_at, :unit
end
