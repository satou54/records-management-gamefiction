json.set! :references_data do
  json.array! @references_data do |reference|
    json.extract! reference, :task, :total_goal, :total_action, :achievement_rate
  end
end
