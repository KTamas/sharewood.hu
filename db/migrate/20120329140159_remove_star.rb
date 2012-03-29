class RemoveStar < ActiveRecord::Migration
  def change
    remove_column :feeds, :star
  end
end
