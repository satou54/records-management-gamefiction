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
    ActionRecord.where(task_id: :task_id).where(action_day: from...to).select(:action).pluck(:action)
  end

  # 既にデータが存在するかチェックする
  def checkActionRecord?(action_day, task_id, user_id)
    ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id)
  end
end
