class Task < ApplicationRecord
  self.primary_key = :task_id
  belongs_to :user

  validates :task, presence: true
  validates :goal, presence: true
end
