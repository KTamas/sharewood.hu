# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  secret_rss_key  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  before_save :create_remember_token
  has_many :relationships, :foreign_key => "user_id", :dependent => :destroy
  has_many :feed_urls, :through => :relationships, :source => :feed_url

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :uniqueness => true, :format => { :with => VALID_EMAIL_REGEX }
  validates :password, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true
  validates :secret_rss_key, :uniqueness => true
  
  def hidden?(feed_url)
    relationships.find_by_feed_url_id(feed_url.id)
  end

  def hide!(feed_url)
    relationships.create!(:feed_url_id => feed_url.id)
  end

  def unhide!(feed_url)
    relationships.find_by_feed_url_id(feed_url.id).destroy
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end

