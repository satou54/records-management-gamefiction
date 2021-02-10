class ActionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :action_day, presence: true
  validates :action, presence: true

  validates :action_day, uniqueness: { scope: :task_id }
end
