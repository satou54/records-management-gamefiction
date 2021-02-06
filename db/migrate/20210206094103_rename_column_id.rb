class RenameColumnId < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :user_id, :id
    rename_column :tasks, :task_id, :id
    rename_column :action_records, :action_record_id, :id
    rename_column :levels, :level_id, :id
  end
end
