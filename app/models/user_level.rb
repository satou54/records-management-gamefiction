class UserLevel < ApplicationRecord
  belongs_to :user

  # ユーザのレベルを取得
  def getUserLevel(user_id)
    UserLevel.find_by(user_id: current_user.id).level
  end

  # ユーザの総経験値を取得
  def getTotalExperiencePoint(user_id)
    UserLevel.find_by(user_id: user_id).total_experience_point
  end

  # ユーザのレベルを登録
  def uploadUserLevel(user_id, level)
    user = UserLevel.find_by(user_id: user_id)
    user.update_attribute("level", level)
  end

  # ユーザの総経験値を登録
  def uploadUserTotalExperiencePoint(user_id, total_experience_point)
    user = UserLevel.find_by(user_id: current_user.id)
    user.update_attribute("total_experience_point", total_experience_point)
  end
end
