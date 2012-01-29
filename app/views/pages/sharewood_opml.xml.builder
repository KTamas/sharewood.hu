# encoding: utf-8
xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.opml :version => "1.0" do
  xml.head do
    xml.title "Sharewood.hu feeds"
  end

  xml.body do
    xml.outline :title => "Sharewood.hu feeds", :text => "Sharewood.hu feeds" do
      for feed_url in @feed_urls do
        xml.outline :text => feed_url.title, :title => feed_url.title, :type => "rss", :xmlUrl => feed_url.feed_url, :htmlUrl => feed_url.site_url
      end
    end
  end
end
