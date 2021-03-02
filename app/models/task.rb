class Task < ApplicationRecord
  belongs_to :user
  has_many :action_records, dependent: :destroy

  validates :task, presence: true, length: { maximum: 30 }
  validates :goal, presence: true, numericality: true
end
