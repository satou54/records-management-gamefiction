class Level < ApplicationRecord

  # 指定したレベルの必要経験値を取得
  def getRequreidExperiecePoint(level)
    Level.find_by(level: level).required_experience_point
  end

  # 次のレベルアップに必要な経験値を計算する
  def getNextLevelRequreidExperiencePoint(level)
    next_level_required_experience_point = getRequreidExperiecePoint(level + 1)
    next_level_required_experience_point - total_experience_point
  end
end
