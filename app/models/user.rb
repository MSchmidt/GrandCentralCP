class User < ActiveRecord::Base
  devise :database_authenticatable
  
  attr_accessor :oldname
  
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
  
  def write_config(pass)
    #add linux user
    #group ftp-user must exist
    Dir.mkdir(self.userpath) unless File.exists?(self.userpath)
    system("useradd -g ftp-user -s /bin/false -d " + self.userpath + " -p #{pass} #{self.username}")
    
    #permission
    system("chown -R #{self.username}:www-data " +  self.userpath) unless self.userfolder.blank?
  end

  def update_config(pass, oldname = nil)
    pass = " -p "+pass unless pass.blank?
    if oldname
      user = "-l "+self.username+" "+oldname
      File.rename(File.join(WWW_DIR,oldname),self.userpath) unless File.exists?(self.userpath) && File.exists?(File.join(WWW_DIR,oldname))
    else
      user = self.username
    end
    
    system("usermod#{pass} #{user}")
    puts "usermod#{pass} #{user}"

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
    self.send_later(:update_config, self.password, self.oldname)
  end

  def del_unix_user
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

