# == Schema Information
#
# Table name: feed_urls
#
#  id         :integer(4)      not null, primary key
#  feed_url   :string(255)
#  title      :string(255)
#  star       :boolean(1)      default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  site_url   :string(255)
#

require 'test_helper'

class FeedUrlTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
