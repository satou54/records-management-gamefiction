class AddDefaultActionExperiencePointToActionRecord < ActiveRecord::Migration[6.1]
  def change
    change_column :action_records, :action_experience_point, :integer, :default => 0
  end
end
