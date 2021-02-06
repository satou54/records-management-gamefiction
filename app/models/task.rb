class Task < ApplicationRecord
  self.primary_key = :task_id
  belongs_to :user
end
