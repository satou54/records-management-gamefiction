class ChangeDataGoalToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :goal, :float
  end
end
