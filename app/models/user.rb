class User < ActiveRecord::Base
  devise :database_authenticatable
  
  has_many :domains
  #, :dependent => :destroy
  has_many :databases
  
  before_validation :set_default_password_if_needed
  
  validates_uniqueness_of :name, :email, :case_sensitive => false
  validates_length_of :name, :maximum => 16
  validates_presence_of :email, :encrypted_password, :dbpassword, :name
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

=begin
  def perform
    write_config
  end
=end
  
  def write_config(pass)
    #add ftp user
    #group ftp-user must exist
    system("useradd -g ftp-user -s /bin/false -d /var/www -p #{pass} #{self.name}")
    #permission
    #system("chown -R #{self.name} #{WWW_DIR}")
    #system("chmod 777 #{WWW_DIR}") #777 zu Testzwecken
  end

  def update_config(pass, oldname = nil)
    pass = " -p "+pass if pass.any?
    if oldname
      user = "-l "+self.name+" "+oldname
    else
      user = self.name
    end
    
    system("usermod#{pass} #{user}")
    puts "usermod#{pass} #{user}"
  end
    
  def destroy_config
    system("userdel #{self.name}")
    self.destroy
  end
  
  protected

  def set_default_password_if_needed
    self.password = User::generate_password if self.encrypted_password.blank?
    self.dbpassword = User::generate_password if self.dbpassword.blank?
  end
  
  public
  
  def self.generate_password(options = {:length => 8})
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    password = ""
    1.upto(options[:length]) { |i| password << chars[rand(chars.size-1)] }
    return password
  end
end

