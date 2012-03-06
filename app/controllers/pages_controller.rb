class PagesController < ApplicationController
  def index
    @feed_urls = FeedUrl.find(:all, :order => :title)
    @feeds = Feed.order("published DESC").page(params[:page])
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def about
    respond_to do |format|
      format.html
    end
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
    #@feeds = Feed.where("content like '%"+query+"%' or title like '%"+query+"%'").order("published DESC").page(params[:page])
    @feeds = Feed.where("content like ? or title like ?", "%#{query}%", "%#{query}%").order("published DESC").page(params[:page])
    render :action => "index"
  end
end
