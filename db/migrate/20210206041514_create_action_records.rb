class CreateActionRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :action_records do |t|
      t.date :action_day, null: false
      t.integer :action, null: false
      t.integer :action_experience_point, null: false
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
