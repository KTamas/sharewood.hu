# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :uniqueness => true, :format => { :with => VALID_EMAIL_REGEX }
  validates :password, :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end

