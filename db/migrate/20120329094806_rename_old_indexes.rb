class RenameOldIndexes < ActiveRecord::Migration
  def change
    rename_index :hidden_feeds, 'index_relationships_on_feed_url_id', 'index_hidden_feeds_on_feed_url_id'
    rename_index :hidden_feeds, 'index_relationships_on_user_id', 'index_hidden_feeds_on_user_id'
    rename_index :hidden_feeds, 'index_relationships_on_user_id_and_feed_url_id', 'index_hidden_feeds_on_user_id_and_feed_url_id'
  end
end
