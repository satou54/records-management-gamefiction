class RenameColumnIdUserId < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :id, :user_id
  end
end
