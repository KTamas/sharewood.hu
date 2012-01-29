class PagesController < ApplicationController
  def index
    @feed_urls = FeedUrl.find(:all, :order => :title)
    @feeds = Feed.paginate(:per_page => 25, :page => params[:page], :order => "published DESC")
    expires_in 5.minutes, :private => false, :public => true
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end
  
  # used to render rss.
  def show
    index
  end
  
  def opml
    @feed_urls = FeedUrl.find(:all, :order => :title)
    respond_to do |format|
      format.xml do
        render 'sharewood_opml.xml.builder', :content_type => 'application/octet-stream'
      end
    end
  end

  # search
  def search
    query = params[:query]
    query = (query && query.strip) || ""
    @feed_urls = FeedUrl.find(:all, :order => :title)
    @feeds = Feed.paginate(:conditions => ["content like ? or title like ?", "%"+query+"%", "%"+query+"%"], 
                           :per_page => 25, 
                           :page => params[:page], 
                           :order => "published DESC")
    render :action => "index"
  end
end
