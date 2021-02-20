json.set! :user_level do
  json.extract! @user_level, :id, :level, :total_experience_point, :user_id, :created_at, :updated_at
end
