class ActionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task, primary_key: :task_id

  validates :action_day, presence: true
  validates :action, presence: true
end
