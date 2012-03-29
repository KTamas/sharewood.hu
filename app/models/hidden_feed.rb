class HiddenFeed < ActiveRecord::Base
  attr_accessible :user_id, :feed_id
  belongs_to :user
  belongs_to :feed
end
