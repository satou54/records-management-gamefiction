class ActionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :action_day, presence: true
  validates :action, presence: true
  validates :action_experience_point, presence: true
  validates :action_day, uniqueness: { scope: [:task_id, :user_id] }

  # 経験値を計算
  # 目標に対する実績の割合1%で経験値1増える
  def culcurateExperiencePoint(action, goal)
    (action.to_f / goal.to_f * 100).floor
  end

  # 実績の経験値を取得
  def getActionExperiencePoint(action_day, task_id, user_id)
    ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id).action_experience_point
  end

  # 実績の経験値を登録
  def uploadActionExperiencePoint(action_day, task_id, user_id, action_experience_point)
    action_record = ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id)
    action_record.update_attribute("action_experience_point", action_experience_point)
  end

  # 引数で指定したタスクの期間の実績を配列で取得
  def weekOfActions(task_id, from, to)
    ActionRecord.where(task_id: task_id).where(action_day: from...to).select(:action).pluck(:action)
  end

  # 既にデータが存在するかチェックする
  def checkActionRecord?(action_day, task_id, user_id)
    ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id)
  end

  # 引数に指定した日付の曜日を取得
  # 日-土が0-6で取得できる
  def getDayOfTheWeek(date)
    date.wday
  end

  # 引数に指定した曜日(日-土が0-6)から1週間の範囲を取得
  # from...toの場合はtoの日付が範囲検索に含まれないため、日曜日ではなく月曜日を指定
  def getWeekRange(action_day, day_of_week)
    case day_of_week
    # 日曜日
    when 0
      from = (action_day - 6.day).at_beginning_of_day
      to = (action_day + 1.day).at_beginning_of_day
      # 月曜日
    when 1
      from = action_day.at_beginning_of_day
      to = (action_day + 7.day).at_beginning_of_day
      # 火曜日
    when 2
      from = (action_day - 1.day).at_beginning_of_day
      to = (action_day + 6.day).at_beginning_of_day
      # 水曜日
    when 3
      from = (action_day - 2.day).at_beginning_of_day
      to = (action_day + 5.day).at_beginning_of_day
      # 木曜日
    when 4
      from = (action_day - 3.day).at_beginning_of_day
      to = (action_day + 4.day).at_beginning_of_day
      # 金曜日
    when 5
      from = (action_day - 4.day).at_beginning_of_day
      to = (action_day + 3.day).at_beginning_of_day
      # 土曜日
    when 6
      from = (action_day - 5.day).at_beginning_of_day
      to = (action_day + 2.day).at_beginning_of_day
    end
    range_of_weeke = [from, to]
  end
end
