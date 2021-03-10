module ActionRecordsReferences
  extend ActiveSupport::Concern
  extend Common

  # １週間
  WEEK = 7

  def getReferencesData(interval)
    # intervalの値に応じてform...toを取得
    case interval
    when "thisWeek"
      today = Time.now
      day_of_week = getDayOfTheWeek(today)
      range_of_week = getWeekRange(today, day_of_week)
      from = range_of_week[0]
      to = range_of_week[1]
    when "thisMonth"
      from = Time.now.beginning_of_month
      to = Time.now.next_month.beginning_of_month
    when "lastMonth"
      from = Time.now.prev_month.beginning_of_month
      to = Time.now.beginning_of_month
    when "lastThreeMonth"
      from = Time.now.ago(3.month).beginning_of_month
      to = Time.now.next_month.beginning_of_month
    when "lastSixMonth"
      from = Time.now.ago(6.month).beginning_of_month
      to = Time.now.next_month.beginning_of_month
    end

    # 期間内の日数を計算
    days = Date.parse(to.to_s) - Date.parse(from.to_s)

    # ユーザのtask_idを配列に入れる
    tasks_ids = current_user.tasks.ids

    # 参照されるデータ一覧
    references_data = []

    tasks_ids.each do |task_id|
      # タスクのidからデータを取得
      task = Task.find(task_id)

      # タスクの名前を変数に代入
      task_name = task.task

      # 期間内の目標の合計値を変数に代入
      total_goal = (task.goal * days.to_i / WEEK).floor(1).to_f

      # 目標の単位を取得
      unit = task.unit

      # 期間内の実績を合計して総実績を取得
      total_action = ActionRecord.weekOfActions(task_id, from, to).sum

      # 達成度を計算し変数に代入
      achievement_rate = (total_action.to_f / total_goal.to_f * Common::PERCENT).floor(1).to_f

      # タスク毎のハッシュを作成
      task_data = {}

      task_data.store(:task, task_name)
      task_data.store(:total_goal, total_goal)
      task_data.store(:unit, unit)
      task_data.store(:total_action, total_action)
      task_data.store(:achievement_rate, achievement_rate)

      # タスクのハッシュを参照用の配列に追加
      references_data.push(task_data)
    end
    references_data
  end
end
