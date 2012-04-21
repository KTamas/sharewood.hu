# encoding: utf-8
xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    if @custom
      xml.title "Sharewood.hu saját feed: #{@user.email}"
    else
      xml.title "Sharewood.hu feed"
    end
    xml.description "Magyar linkblog közösség. Alapítva 2012-ben."
    xml.link "http://sharewood.hu/"
    unless @custom
      xml.link :rel => "hub", :href => "http://sharewood.superfeedr.com", :xmlns => "http://www.w3.org/2005/Atom"
      xml.link :rel => "self", :href => "http://sharewood.hu/index.rss", :xmlns => "http://www.w3.org/2005/Atom"
    end
    for item in @items
      xml.item do
        xml.title item.title + " (" + item.feed.title + " osztotta meg)"
        xml.description fix_host(item.clean_content, item.site_link)
        xml.pubDate item.published.to_s(:rfc822)
        xml.link item.link
        xml.guid Digest::MD5.hexdigest(item.link), :isPermaLink => "false"
      end
    end
  end
end

