class User < ActiveRecord::Base
  devise :database_authenticatable
  
  has_many :domains, :dependent => :destroy
  has_many :databases, :dependent => :destroy
  
  before_validation :set_default_password_if_needed, :set_default_userfolder_if_needed
  after_create :add_unix_user
  after_update :mod_unix_user
  after_destroy :del_unix_user
  
  validates_uniqueness_of :username, :email, :case_sensitive => false
  validates_length_of :username, :within => 3..16
  validates_presence_of :email, :encrypted_password, :dbpassword, :username
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  def username=(new_username)
    write_attribute(:old_username, read_attribute(:username))
    write_attribute(:username, new_username)
  end
  
  def old_username
    read_attribute(:old_username) 
  end

  def write_config(pass)
    #add linux user
    #group ftp-user must exist
    Dir.mkdir(self.userpath) unless File.exists?(self.userpath)
    system("useradd -g ftp-user -s /bin/false -d " + self.userpath + " -p #{pass} #{self.username}")
    
    #permission
    system("chown -R #{self.username}:www-data " +  self.userpath) unless self.userfolder.blank?
  end

  def update_config(pass,old_username)
    pass = " -p " + pass unless pass.blank?
    
    if self.username != old_username
      user = "-l " + self.username + " " + old_username
      
      # Only rename user folder when user had folder similar to old username before
      # which indicates that he stuck to the standard naming behaviour.
      # Also make sure requested foldername is not taken yet.
      if File.exists?(File.join(WWW_DIR, old_username)) && !File.exists?(self.userpath)
        File.rename(File.join(WWW_DIR, old_username), self.userpath)
      end
      
    else
      user = self.username
    end
    
    system("usermod#{pass} #{user}")
  end
    
  def destroy_config
    system("userdel #{self.username}")
  end
  
  def userpath
    File.join(WWW_DIR,self.userfolder)
  end
  
  
  protected

  def set_default_password_if_needed
    self.password = User::generate_password if self.encrypted_password.blank?
    self.dbpassword = User::generate_password if self.dbpassword.blank?
  end
  
  def set_default_userfolder_if_needed
    if self.userfolder
      self.userfolder = self.username
    else
      self.userfolder = ""
    end
  end
    
  def add_unix_user
    self.send_later(:write_config, self.password)
  end
  
  def mod_unix_user
    ConnectedDatabase::change_user_password(:name => self.username, :password => self.dbpassword) if self.dbpassword_changed?
    ConnectedDatabase::rename_user(:name => self.username, :oldname => old_username) if self.username != old_username
    self.send_later(:update_config, self.password, self.old_username)
  end

  def del_unix_user
    ConnectedDatabase::destroy_user(:name => self.username)
    self.send_later(:destroy_config)
  end
  
  public
  
  def self.generate_password(options = {:length => 8})
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    password = ""
    1.upto(options[:length]) { |i| password << chars[rand(chars.size-1)] }
    return password
  end
end

