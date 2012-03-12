require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :utils do

  # Populates feeds table.
  task(:populate_feeds => :environment) do
    feed_urls = FeedUrl.find(:all)
    feed_urls.each do |feed_url|
      begin
        xml = feed_url.fetch_feed.force_encoding("UTF-8")
        feed_url.process_feed(xml)
      rescue Exception => e
        puts e.message
      end
    end
    ping_services
  end

  # Removes duplicate feeds.
  task(:delete_duplicate_feeds => :environment) do
    FeedUrl.cleanup_feeds()
  end

  task(:subscribe_all => :environment) do
    feed_urls = FeedUrl.find(:all)
    feed_urls.each do |feed_url|
      Planet::Application::Superfeedr.subscribe(feed_url.feed_url)
    end
  end

  task(:unsubscribe_all => :environment) do
    feed_urls = FeedUrl.find(:all)
    feed_urls.each do |feed_url|
      Planet::Application::Superfeedr.unsubscribe(feed_url.feed_url)
    end
  end
end
