class AddLeveltoUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :level, :integer, null: false, default: 1
  end
end
