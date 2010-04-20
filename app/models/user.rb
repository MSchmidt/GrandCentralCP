class User < ActiveRecord::Base

  devise :database_authenticatable
  
  before_validation :set_default_password_if_needed
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :email, :encrypted_password
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'must be valid'
  
  protected
  
  def set_default_password_if_needed
    self.password = User::generate_password if self.encrypted_password.blank?
  end
  
  
  public
  
  def self.generate_password(options = {:length => 8})
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    password = ""
    1.upto(options[:length]) { |i| password << chars[rand(chars.size-1)] }
    return password
  end

end