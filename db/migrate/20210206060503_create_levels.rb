class CreateLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :levels do |t|
      t.integer :level, null: false
      t.integer :required_experience_point, null: false

      t.timestamps
    end
  end
end
