# encoding: utf-8
xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.opml :version => "1.0" do
  xml.head do
    xml.title "Sharewood.hu feeds"
  end

  xml.body do
    xml.outline :title => "Sharewood.hu feeds", :text => "Sharewood.hu feeds" do
      for feed in @feeds do
        xml.outline :text => feed.title, :title => feed.title, :type => "rss", :xmlUrl => feed.url, :htmlUrl => feed.site_url
      end
    end
  end
end
