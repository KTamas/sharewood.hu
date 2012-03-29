class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.secret_rss_key = Digest::SHA1.hexdigest("#{Time.now}#{rand(1000000)}") # random enough
    if @user.save
      sign_in @user
      redirect_to root_path
    else
      render 'new'
    end
  end

end
