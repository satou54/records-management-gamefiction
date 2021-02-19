class Task < ApplicationRecord
  belongs_to :user
  has_many :action_records, dependent: :destroy

  validates :task, presence: true
  validates :goal, presence: true

  # idからtaskのgoalを取得
  def getGoal(task_id)
    Task.find(task_id).goal
  end
end
