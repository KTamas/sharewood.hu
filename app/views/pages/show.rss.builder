xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do

    xml.title "Sharewood.hu feed"
    xml.description "Description goes here."
    xml.link "http://sharewood.hu/pages/show.rss"

    for feed in @feeds
      xml.item do
        xml.title feed.title
        xml.description fix_host(feed.content, feed.site_link)
        xml.pubDate feed.published.to_s(:rfc822)
        xml.link feed.link
        xml.guid Digest::MD5.hexdigest(feed.link)
      end
    end
  end
end

