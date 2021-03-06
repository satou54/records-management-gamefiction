module Common
  extend ActiveSupport::Concern

  PERCENT = 100

  # 経験値を計算
  # 目標に対する実績の割合1%で経験値1増える
  def culcurateExperiencePoint(action, goal)
    (action.to_f / goal.to_f * PERCENT).floor
  end

  # 引数に指定した日付の曜日を取得
  # 日-土が0-6で取得できる
  def getDayOfTheWeek(date)
    date.wday
  end

  # 引数に指定した曜日(日-土が0-6)から1週間の範囲を取得
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
