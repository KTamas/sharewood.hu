class PagesController < ApplicationController
  def index
    @feed_urls = FeedUrl.find(:all, :order => :title)
    if signed_in?
      active_feeds = current_user.feed_urls.select('feed_url_id').map(&:feed_url_id).join(',')
      @feeds = Feed.where("feed_url_id IN (#{active_feeds})").order("published DESC").page(params[:page])
    else
      @feeds = Feed.order("published DESC").page(params[:page])
    end
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def custom_rss
    @user = User.find_by_secret_rss_key(params[:secret_rss_key])
    active_feeds = @user.feed_urls.select('feed_url_id').map(&:feed_url_id).join(',')
    @feeds = Feed.where("feed_url_id IN (#{active_feeds})").order("published DESC").page(params[:page])
    render 'index.rss', :handler => [:builder], :content_type => 'application/rss+xml'
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
