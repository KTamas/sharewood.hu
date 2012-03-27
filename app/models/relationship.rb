class Relationship < ActiveRecord::Base
  attr_accessible :user_id, :feed_url_id
  belongs_to :user
  belongs_to :feed_url
end
