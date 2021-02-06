class CreateActionRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :action_records, id: false do |t|
      t.column :action_record_id, "INTEGER PRIMARY KEY AUTO_INCREMENT"
      t.date :action_day, null: false
      t.integer :action, null: false
      t.integer :action_experience_point, null: false
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, type: :integer

      t.timestamps
    end
    add_foreign_key :action_records, :tasks, column: :task_id, primary_key: :task_id
  end
end
