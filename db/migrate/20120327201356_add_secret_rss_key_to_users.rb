class AddSecretRssKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secret_rss_key, :string

  end
end
