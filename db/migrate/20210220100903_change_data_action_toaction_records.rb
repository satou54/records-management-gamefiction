class ChangeDataActionToactionRecords < ActiveRecord::Migration[6.1]
  def change
    change_column :action_records, :action, :float
  end
end
