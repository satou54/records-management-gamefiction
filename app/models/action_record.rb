class ActionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :action_day, presence: true
  validates :action, presence: true

  validates :action_day, uniqueness: { scope: :task_id }

  # 引数で指定したタスクの期間の実績を配列で取得
  def weekOfActions(task_id, from, to)
    ActionRecord.where(task_id: :task_id)
      .where(action_day: from...to).select(:action).pluck(:action)
  end

  # 既にデータが存在するかチェックする
  def checkActionRecord?(action_day, task_id, user_id)
    ActionRecord.find_by(action_day: action_day, task_id: task_id, user_id: user_id)
  end
end
