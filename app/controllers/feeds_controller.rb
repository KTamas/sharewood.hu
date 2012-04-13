class FeedsController < ApplicationController
  before_filter :authenticate

  def index
    @feeds = Feed.find(:all)
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @feed = Feed.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @feed = Feed.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def create
    @feed = Feed.new(params[:feed])

    respond_to do |format|
      if @feed.save
        flash[:notice] = 'Feed was successfully created.'
        Planet::Application::Superfeedr.subscribe(@feed.url)
        format.html { redirect_to(@feed) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @feed = Feed.find(params[:id])
    Planet::Application::Superfeedr.unsubscribe(@feed.url)

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        Planet::Application::Superfeedr.subscribe(@feed.url)
        flash[:notice] = 'Feed was successfully updated.'
        format.html { redirect_to(@feed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.xml
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    Planet::Application::Superfeedr.unsubscribe(@feed.url)
    respond_to do |format|
      format.html { redirect_to(feeds_url) }
      format.xml  { head :ok }
    end
  end

  def login
    session[:authenticated] = true
    render :text => "You have successfully logged in. <a href='/blog'>Back</a>"
  end

  # One way to logout from http authentication.
  # But it is specific to some browsers. So it won't work always.
  def logout
    render :text => "You logged out. <a href='/blog'>Back</a>", :status => 401
    session[:authenticated] = false
  end

  protected
  def authenticate
     authenticate_or_request_with_http_basic do | user_name, password|
      pwd = YAML::load_file("/etc/password.yml")["password"]
      user_name == "root" && password == pwd
    end
  end

end
