# == Schema Information
#
# Table name: hidden_feeds
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  feed_id    :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class HiddenFeed < ActiveRecord::Base
  attr_accessible :user_id, :feed_id
  belongs_to :user
  belongs_to :feed
end
