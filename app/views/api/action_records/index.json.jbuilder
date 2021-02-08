json.set! :action_records do
  json.array! @action_records do |action_record|
    json.extract! action_record, :id, :action_day, :action,
                  :action_experience_point,
                  :user_id, :task_id, :created_at,
                  :updated_at
  end
end
