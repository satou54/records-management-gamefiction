class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: false do |t|
      t.column :task_id, "INTEGER PRIMARY KEY AUTO_INCREMENT"
      t.string :task, null: false
      t.integer :goal, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
