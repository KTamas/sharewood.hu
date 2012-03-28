# == Schema Information
#
# Table name: relationships
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  feed_url_id :integer(4)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :user_id, :feed_url_id
  belongs_to :user
  belongs_to :feed_url
end
