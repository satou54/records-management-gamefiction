class UserLevel < ApplicationRecord
  belongs_to :user

  validates :level, presence: true
  validates :total_experience_point, presence: true

  def self.getUserLevel(user_id)
    UserLevel.find_by(user_id: user_id).level
  end
  def self.getTotalExperiencePoint(user_id)
    UserLevel.find_by(user_id: user_id).total_experience_point
  end

  def self.uploadUserLevel(user_id, level)
    user = UserLevel.find_by(user_id: user_id)
    user.update_attribute("level", level)
  end

  def self.uploadUserTotalExperiencePoint(user_id, total_experience_point)
    user = UserLevel.find_by(user_id: user_id)
    user.update_attribute("total_experience_point", total_experience_point)
  end
end
