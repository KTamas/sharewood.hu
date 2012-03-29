class RenameFeedUrlsToFeeds < ActiveRecord::Migration
  def change
    rename_table :feed_urls, :feeds
    rename_column :feeds, :feed_url, :url
    remove_index :hidden_feeds, :feed_url_id
    remove_index :hidden_feeds, [:user_id, :feed_url_id]
    rename_column :hidden_feeds, :feed_url_id, :feed_id
    add_index :hidden_feeds, :feed_id
    add_index :hidden_feeds, [:user_id, :feed_id], :unique => true
    rename_column :items, :feed_url_id, :feed_id
  end
end
