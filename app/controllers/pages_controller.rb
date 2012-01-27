class PagesController < ApplicationController
  def index
    @feed_urls = FeedUrl.find(:all, :order => :title)
    @feeds = Feed.paginate(:per_page => 25, :page => params[:page], :order => "published DESC")
    expires_in 5.minutes, :private => false, :public => true
  end
  
  # used to render rss.
  def show
    index
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
  
  # channels
  def channels
    @feed_urls = FeedUrl.find(:all, :order => :title)
    render :layout => false
  end
end
