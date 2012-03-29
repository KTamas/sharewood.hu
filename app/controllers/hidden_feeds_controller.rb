class HiddenFeedsController < ApplicationController
  before_filter :signed_in_user

  def create
    current_user.hide!(FeedUrl.find(params[:id]))
    redirect_to root_path
  end

  def destroy
    current_user.unhide!(FeedUrl.find(params[:id]))
    redirect_to root_path
  end
end
