# == Schema Information
#
# Table name: feeds
#
#  id          :integer(4)      not null, primary key
#  feed_url_id :integer(4)
#  title       :string(255)
#  author      :string(255)
#  link        :string(255)
#  site_link   :string(255)
#  site_title  :string(255)
#  content     :text
#  published   :datetime
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
