json.set! :tasks do
  json.array! @tasks do |task|
    json.extract! task, :id, :task, :goal, :user_id, :created_at, :updated_at, :unit
  end
end
