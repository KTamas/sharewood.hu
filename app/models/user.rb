class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  before_save :create_remember_token
  has_many :hidden_feeds, :foreign_key => "user_id", :dependent => :destroy
  has_many :feeds, :through => :hidden_feeds, :source => :feed

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :uniqueness => true, :format => { :with => VALID_EMAIL_REGEX }
  validates :password, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true
  validates :secret_rss_key, :uniqueness => true
  
  def hidden?(feed)
    hidden_feeds.find_by_feed_id(feed.id)
  end

  def hide!(feed)
    hidden_feeds.create!(:feed_id => feed.id)
  end

  def unhide!(feed)
    hidden_feeds.find_by_feed_id(feed.id).destroy
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end

