class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :feed_url_id

      t.timestamps
    end
    add_index :relationships, :user_id
    add_index :relationships, :feed_url_id
    add_index :relationships, [:user_id, :feed_url_id], :unique => true
  end
end
