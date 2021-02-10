class AddIndexActionRecordsActionDay < ActiveRecord::Migration[6.1]
  def change
    add_index :action_records, [:action_day, :task_id], unique: true
  end
end
