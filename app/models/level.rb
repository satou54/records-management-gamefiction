class Level < ApplicationRecord

  def self.getRequreidExperiecePoint(level)
    Level.find_by(level: level).required_experience_point
  end
end
