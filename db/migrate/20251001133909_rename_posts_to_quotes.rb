class RenamePostsToQuotes < ActiveRecord::Migration[8.0]
  def change
    rename_table :microposts, :quotes
    rename_column :quotes, :member_id, :author_id
  end
end
