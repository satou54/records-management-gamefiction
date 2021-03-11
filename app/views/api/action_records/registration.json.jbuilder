json.set! :level_up_data do
  json.extract! @levelup_data, :action_record_id, :before_level, :after_level,
                :before_experience_point_percent,
                :after_experience_point_percent
end
