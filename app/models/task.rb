class Task < ApplicationRecord
  belongs_to :user
  has_many :action_records

  validates :task, presence: true
  validates :goal, presence: true
end
