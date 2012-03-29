require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :utils do

  # Populates feeds table.
  task(:populate_feeds => :environment) do
    feeds = Feed.find(:all)
    feeds.each do |feed|
      begin
        xml = feed.fetch_feed.force_encoding("UTF-8")
        feed.process_feed(xml)
      rescue Exception => e
        puts e.message
      end
    end
    ping_services
  end

  # Removes duplicate feeds.
  task(:delete_duplicate_feeds => :environment) do
    Feed.cleanup_feeds()
  end

  task(:subscribe_all => :environment) do
    feeds = Feed.find(:all)
    feeds.each do |feed|
      Planet::Application::Superfeedr.subscribe(feed.url)
    end
  end

  task(:unsubscribe_all => :environment) do
    feeds = Feed.find(:all)
    feeds.each do |feed|
      Planet::Application::Superfeedr.unsubscribe(feed.url)
    end
  end
end
