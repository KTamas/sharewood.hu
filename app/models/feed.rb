# == Schema Information
#
# Table name: feeds
#
#  id         :integer(4)      not null, primary key
#  url        :string(255)
#  title      :string(255)
#  star       :boolean(1)      default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  site_url   :string(255)
#

class Feed < ActiveRecord::Base

  has_many :items, :dependent => :delete_all
  validates_presence_of :url
  validates_presence_of :title
  belongs_to :user

  def process_feed(xml)
    doc = Nokogiri.XML(xml)
    if doc.search(:rss).size > 0 # vanilla RSS
      process_rss(doc)
      return 'rss'
    elsif doc.search(:last_fetch).size > 0 # superfeedr atom
      process_atom(doc)
      return 'atom'
    elsif doc.search(:feed).size > 0 # google reader atom
      process_atom_reader(doc)
      return 'atom_reader'
    else
      raise RuntimeError, 'Unknown feed type only RSS, atom and atom_reader can be read'
    end
  end

  # Process rss feed and saves it into db
  def process_rss(rss)
    time_offset = 1

    # taking out site/blog link and title.
    site_link = (rss/:channel/:link).first.inner_html
    site_title = (rss/:channel/:title).first.inner_html
    puts "processing rss for #{site_link}"

    (rss/:channel/:item).each do |item|
      link_raw = item.%('feedburner:origLink') || item.%('link') || (item/:link)
      link = link_raw.inner_html

      if (Item.find_by_link(link)).blank?
        rss_item = Item.new
        rss_item.url = self
        rss_item.site_link = site_link
        rss_item.site_title = site_title
        rss_item.title = (item/:title).inner_html
        rss_item.link = link
        rss_item.author = (item/:author).inner_html
        rss_item.content = (item/:description).inner_html
        if rss.namespaces.include?("xmlns:content")
          if item.xpath('content:encoded').length == 1
            rss_item.content = item.xpath('content:encoded').inner_html
          else
            rss_item.content = (item/:description).inner_html
          end
        end

        rss_item.published = (item/:pubDate).inner_html

        if rss_item.published.blank?
          puts "rss feed published time blank. calculating system one."
          # taking it 20 days back..
          rss_item.published = (Time.now - (20*60*60*24) - time_offset.hours).to_s(:db)
          time_offset += 1
        end

        rss_item.title = htmlize(rss_item.title)
        rss_item.content = htmlize(rss_item.content, link)
        rss_item.save!
      end
    end
  end

  # Process atom feed and saves it into db
  def process_atom(atom)
    # taking out site/blog link and title.
    site_link =  (atom/:feed/:id).first.inner_html
    site_title = (atom/:feed/:title).first.inner_html

    puts "processing atom for #{site_link}"

    (atom/:entry).each do |item|
      link = (item/:link).first.attr('href')

      if (Item.find_by_link(link)).blank?
        atom_item = Item.new
        atom_item.url = self
        atom_item.site_link = site_link
        atom_item.site_title = site_title
        atom_item.title = (item/:title).inner_html
        atom_item.link = link
        atom_item.author = (item/:author/:name).inner_html

        atom_item.content = (item/:content).inner_html
        if atom_item.content.blank?
          atom_item.content = (item/:summary).inner_html
        end

        atom_item.published = (item/:published).inner_html
        if atom_item.published.blank?
          atom_item.published = (item/:updated).inner_html
        end

        atom_item.title = htmlize(atom_item.title)
        atom_item.content = htmlize(atom_item.content, link)

        atom_item.save!
      end
    end
  end

  # Process atom_reader feed and saves it into db
  def process_atom_reader(atom_reader)
    time_offset = 1

    # taking out site/blog link and title.
    site_link =  (atom_reader/:feed).search(:link)[1]['href']
    site_title = (atom_reader/:feed/:title).first.inner_html

    puts "processing atom_reader for #{site_link}"

    (atom_reader/:entry).each do |item|
      link_raw = item.%('feedburner:origLink') || item.%('link')

     # if !link_raw.blank?
     #   link = (link_raw).inner_html
     # else
        link = (item/:link).attr('href').value
     # end
      if (Item.find_by_link(link)).blank?
        atom_reader_item = Item.new
        atom_reader_item.url = self
        atom_reader_item.site_link = site_link
        atom_reader_item.site_title = site_title
        atom_reader_item.title = (item/:title).children[0].text + " - " + (item/:title).children[1].text
        atom_reader_item.link = link
        atom_reader_item.author = (item/:author/:name).inner_html
        begin
          atom_reader_item.content = (item/:content).children[0].text
        rescue
          atom_reader_item.content = (item/:summary).inner_html
        end
        atom_reader_item.published = (item/:published).inner_html

        if atom_reader_item.content.blank?
          atom_reader_item.content =  (item/:summary).inner_html
        end

        if atom_reader_item.published.blank?
          atom_reader_item.published =  (item/:updated).inner_html
        end

        if atom_reader_item.published.blank?
          # taking it 20 days back..
          atom_reader_item.published =  (Time.now - (20*60*60*24) - time_offset.hours).to_s(:db)
          time_offset += 1
        end

        atom_reader_item.title = htmlize(atom_reader_item.title)
        atom_reader_item.content = htmlize(atom_reader_item.content, link)
        atom_reader_item.save!
      end
    end
  end

  # Fetches RSS feed and returns back xml
  def fetch_feed
    rss = ""
    begin
      f = open(self.url, 'r')
      rss = f.read()
      f.close
    rescue Exception => e
      puts e.message
      puts "Feed::fetch_feed :: Error in opening feed"
    end
    return rss
  end

  # htmlize the html codes back.
  def htmlize(string, link=nil)
    string.gsub!('&lt;', '<')
    string.gsub!('&gt;', '>')
    string.gsub!('&amp;', '&')
    string.gsub!('&#39;', "'")
    string.gsub!('&quot;', '"')
    string.gsub!('<![CDATA[', '')
    string.gsub!(']]>', '')

    # for image srcs like <img src="/assets/2008/4/23/rails3.jpg_1208810865" />"
    # adding host so that they become valid
    # "<img src="http://www.google.com/assets/2008/4/23/rails3.jpg_1208810865" />"
#    if link
#        host = URI.parse(link).host
#        if host != "feeds.feedburner.com"
#          string.gsub!("src=\"/", "src=\"http://"+host+"/")
#        end
#    end
    return string
  end

  ## Removed duplicate entries
  ## Currently based on feed title. #TODO make it more correct.
  def self.cleanup_feeds
    feed_records = Feed.find_by_sql("select count(title) as qty, feeds.id as feed_id from feeds group by title having qty > 1;")
    feed_ids = (feed_records.collect{|i| i.feed_id})
    Item.delete(feed_ids)
  end

end

