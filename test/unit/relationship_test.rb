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

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
