class Domain < ActiveRecord::Base
  belongs_to :user
  
  after_create :create_vhost
  after_update :create_vhost
  after_destroy :destroy_vhost
  
  validates_presence_of :fqdn, :mount_point
  validates_uniqueness_of :fqdn
  validates_length_of :fqdn, :minimum => 4
  validates_presence_of :user_id
  
  def generate_vhost
    servername = self.fqdn
    serveralias = "www." + servername
    email = self.user.email
    path = File.join(self.user.userpath, self.mount_point)
    php = self.php
    rails = self.rails
      
    vhost_template = ERB.new(read_template('apache2_vhost.conf')).result(binding)
  end
  
  def generate_default_index
    servername = self.fqdn
    php = self.php
      
    index_template = ERB.new(read_template('index.html')).result(binding)
  end
  
  def write_config      
    vhost_template = generate_vhost
    index_template = generate_default_index
    path = File.join(self.user.userpath, self.mount_point)
      
    File.open(File.join(VHOST_TARGET_DIR, VHOST_PREFIX + self.fqdn), "w") do |f|
      f.write(vhost_template)
    end
      
    Dir.mkdir(path) unless File.exists?(path)
    
    indexfile = self.php ? File.join(path, "index.php") : File.join(path, "index.html")
      
    unless File.exists?(indexfile)
      File.open(indexfile, "w") do |f|
        f.write(index_template)
      end
    end
      
    system("a2ensite " + VHOST_PREFIX + self.fqdn)
    system("/etc/init.d/apache2 reload")
      
    rescue Errno::ENOENT
      puts "No such directory"
  end
  
  def read_template(file)
    IO.read(RAILS_ROOT + '/app/templates/'+file)
  end
  
  def destroy_config
    transaction do
      destroy
      begin
        system("a2dissite " + VHOST_PREFIX + self.fqdn)
        
        vhost_path = File.join(VHOST_TARGET_DIR, VHOST_PREFIX + self.fqdn)
        File.delete(vhost_path) if File.exist?(vhost_path)
        
        system("/etc/init.d/apache2 reload")
      rescue Errno::ENOENT
        puts "No such directory"
      end
     end
  end
  
  protected
  
  def create_vhost
    self.send_later(:write_config)
  end
  def destroy_vhost
    self.send_later(:destroy_config)
  end
end
