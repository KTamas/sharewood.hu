class PagesController < ApplicationController
  def index
    @feeds = Feed.find(:all, :order => :title)
    if signed_in?
      hidden_feeds = current_user.feeds.select('feed_id').map(&:feed_id).join(',')
      unless hidden_feeds.blank?
        @items = Item.where("feed_id NOT IN (#{hidden_feeds})").order("published DESC").page(params[:page])
      else
        @items = Item.order("published DESC").page(params[:page])
      end
    else
      @items = Item.order("published DESC").page(params[:page])
    end
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def custom_rss
    @user = User.find_by_secret_rss_key(params[:secret_rss_key])
    hidden_feeds = @user.feeds.select('feed_id').map(&:feed_id).join(',')
    @custom = true
    unless hidden_feeds.blank?
      @items = Item.where("feed_id NOT IN (#{hidden_feeds})").order("published DESC").page(params[:page])
    else
      @items = Item.order("published DESC").page(params[:page])
    end
    render 'index.rss', :handler => [:builder], :content_type => 'application/rss+xml'
  end

  def about
    respond_to do |format|
      format.html
    end
  end

  def opml
    @feeds = Feed.find(:all, :order => :title)
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
    @feeds = Feed.find(:all, :order => :title)
    @items = Item.where("content like ? or title like ?", "%#{query}%", "%#{query}%").order("published DESC").page(params[:page])
    render :action => "index"
  end
end
