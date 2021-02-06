class CreateLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :levels, id: false do |t|
      t.column :level_id, "INTEGER PRIMARY KEY AUTO_INCREMENT"
      t.integer :level, null: false
      t.integer :required_experience_point, null: false

      t.timestamps
    end
  end
end
