class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    current_user.subscribe!(FeedUrl.find(params[:id]))
    redirect_to root_path
  end

  def destroy
    current_user.unsubscribe!(FeedUrl.find(params[:id]))
    redirect_to root_path
  end
end
