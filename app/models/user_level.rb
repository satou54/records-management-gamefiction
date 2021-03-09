class UserLevel < ApplicationRecord
  belongs_to :user

  validates :level, presence: true
  validates :total_experience_point, presence: true

  # ユーザのレベルを取得
  def self.getUserLevel(user_id)
    UserLevel.find_by(user_id: user_id).level
  end

  # ユーザの総経験値を取得
  def self.getTotalExperiencePoint(user_id)
    UserLevel.find_by(user_id: user_id).total_experience_point
  end

  # ユーザのレベルを登録
  def self.uploadUserLevel(user_id, level)
    user = UserLevel.find_by(user_id: user_id)
    user.update_attribute("level", level)
  end

  # ユーザの総経験値を登録
  def self.uploadUserTotalExperiencePoint(user_id, total_experience_point)
    user = UserLevel.find_by(user_id: user_id)
    user.update_attribute("total_experience_point", total_experience_point)
  end
end
