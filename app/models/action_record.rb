class ActionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :task, primary_key: :task_id
end
