class RenameRelationshipsToHiddenFeeds < ActiveRecord::Migration
  def change
    rename_table :relationships, :hidden_feeds
  end
end
