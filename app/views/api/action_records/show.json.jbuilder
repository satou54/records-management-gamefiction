json.set! :action_record do
  json.extract! @action_record, :id, :action_day, :action,
                :action_experience_point,
                :user_id, :task_id, :created_at,
                :updated_at
end
