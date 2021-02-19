class CreateUserLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :user_levels do |t|
      t.integer :level, null: false
      t.integer :total_experience_point, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
