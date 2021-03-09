class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :task, null: false
      t.integer :goal, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
