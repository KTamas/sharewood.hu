# encoding: utf-8
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Sharewood.hu feed"
    xml.description "Magyar linkblog közösség. Alapítva 2012-ben."
    xml.link "http://sharewood.hu/"
    xml.link :rel => "hub", :href => "http://sharewood.superfeedr.com", :xmlns => "http://www.w3.org/2005/Atom"
    xml.link :rel => "self", :href => "http://sharewood.hu/index.rss", :xmlns => "http://www.w3.org/2005/Atom"
    for feed in @feeds
      xml.item do
        xml.title feed.title + " (" + feed.feed_url.title + " osztotta meg)"
        xml.description fix_host(feed.clean_content, feed.site_link)
        xml.pubDate feed.published.to_s(:rfc822)
        xml.link feed.link
        xml.guid Digest::MD5.hexdigest(feed.link), :isPermaLink => "false"
      end
    end
  end
end
