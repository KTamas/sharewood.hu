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

    if Rails.env.production?
      # feedburner
      puts "Pinging feedburner..."
      begin
        require 'xmlrpc/client'
        fb = XMLRPC::Client.new2("http://ping.feedburner.google.com/")
        result = fb.call('weblogUpdates.ping', "Sharewood.hu feed", "http://feeds.feedburner.com/Sharewoodhu")
        puts result['message']
      rescue Exception => e
        puts "Nope, that didn't work."
        puts e.message
      end

      puts "Pinging superfeedr..."
      begin
        require 'net/http'
        uri = URI("http://sharewood.superfeedr.com")
        res = Net::HTTP.post_form(uri, 'hub.mode' => 'publish', 'hub.url' => 'http://sharewood.hu/index.rss')
        puts res.code
      rescue Exception => e
        puts "Nope, that didn't work."
        puts e.message
      end
    end
  end

  # Removes duplicate feeds.
  task(:delete_duplicate_feeds => :environment) do
    FeedUrl.cleanup_feeds()
  end

end
