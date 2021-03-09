class ActionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :action_day, presence: true
  validates :action, presence: true, numericality: true
  validates :action_experience_point, presence: true, numericality: true
  validates :action_day, uniqueness: { scope: [:task_id, :user_id] }

  PERCENT = 100

  # 実績の経験値を取得
  def self.getActionExperiencePoint(action_day, task_id, user_id)
    ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id).action_experience_point
  end

  # 実績の経験値を登録
  def self.uploadActionExperiencePoint(action_day, task_id, user_id, action_experience_point)
    action_record = ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id)
    action_record.update_attribute("action_experience_point", action_experience_point)
  end

  # 引数で指定したタスクの期間の実績を配列で取得
  def self.weekOfActions(task_id, from, to)
    ActionRecord.where(task_id: task_id).where(action_day: from...to).select(:action).pluck(:action)
  end

  # 既にデータが存在するかチェックする
  def self.getActionRecord(action_day, task_id, user_id)
    ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id)
  end
end
