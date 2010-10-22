# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  email               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  username            :string(255)
#

class User < ActiveRecord::Base
  
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
    config.perishable_token_valid_for = 1.hour
  end
  
  belongs_to :user
  
  has_many :videos
  has_many :logs
    
  validates_presence_of :name,
                        :username
  
  validates_uniqueness_of :name, 
                          :username, :case_sensitive => false
  
  # validates_format_of :username, :with => /\A\w+\z/i,
  #                                :message => 'only letters, numbers, and underscores please'
                                 
  validates_exclusion_of :username, :in => BLACKLIST_USERNAMES,
                                    :message => 'is not allowed'
      
  
  def self.find_by_username_or_email(login)
    find_by_username(login) || find_by_email(login)
  end
  
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Emailer.deliver_password_reset_instructions(self)
  end
    
end
