class Level < ApplicationRecord

  # 指定したレベルの必要経験値を取得
  def getRequreidExperiecePoint(level)
    Level.find_by(level: level).required_experience_point
  end
end