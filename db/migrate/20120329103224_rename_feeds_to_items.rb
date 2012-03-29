class RenameFeedsToItems < ActiveRecord::Migration
  def change
    rename_table :feeds, :items
  end
end
