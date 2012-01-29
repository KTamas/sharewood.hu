# encoding: utf-8
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do

    xml.title "Sharewood.hu feed"
    xml.description "Description goes here."
    xml.link "http://sharewood.hu/pages/show.rss"

    for feed in @feeds
      xml.item do
        xml.title feed.title + " (shared by " + feed.feed_url.title + ")"
        xml.description fix_host(Sanitize.clean(feed.content, :elements => %w[a abbr b blockquote br div cite code em i li ol p pre s small strike strong sub sup u ul var object iframe embed img], :attributes => { 'a' => ['href'], 'img' => ['src', 'width', 'height'], 'iframe' => ['src', 'allowfullscreen', 'frameborder', 'height', 'width'], 'embed' => ['src', 'height', 'width', 'allowscriptaccess', 'allowfullscreen', 'flashvars'] }), feed.site_link)
        xml.pubDate feed.published.to_s(:rfc822)
        xml.link feed.link
        xml.guid Digest::MD5.hexdigest(feed.link)
      end
    end
  end
end

