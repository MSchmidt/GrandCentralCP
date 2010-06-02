class Domain < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :fqdn, :mount_point
  validates_uniqueness_of :fqdn
  validates_length_of :fqdn, :minimum => 4
  validates_presence_of :user_id
  
  def perform
    write_config
  end
  
  def write_config
    servername = self.fqdn
    serveralias = "www." + servername
    email = self.user.email
    path = File.join(WWW_DIR,self.mount_point)
    php = self.php
    rails = self.rails
      
    vhost_template = ERB.new(read_template('apache2_vhost.conf')).result(binding)
    index_template = ERB.new(read_template('index.html')).result(binding)
      
    File.open(File.join(VHOST_TARGET_DIR,VHOST_PREFIX + servername), "w") do |f|
      f.write(vhost_template)
    end
      
    Dir.mkdir(path) unless File.exists?(path)
      
    indexfile = File.join(path, "index.html")
    indexfile = File.join(path, "index.php") if php
      
    unless File.exists?(indexfile)
      File.open(indexfile, "w") do |f|
        f.write(index_template)
      end
    end
      
    system("a2ensite #{VHOST_PREFIX+servername}")
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
        servername = self.fqdn
        folder = self.mount_point
        
        system("a2dissite #{VHOST_PREFIX+servername}")
        
        vhost_path = File.join(VHOST_TARGET_DIR, VHOST_PREFIX + servername)
        File.delete(vhost_path) if File.exist?(vhost_path)
        #system("rm -rf " + File.join(WWW_DIR, self.mount_point))
        
        system("/etc/init.d/apache2 reload")
        
      rescue Errno::ENOENT
        puts "No such directory"
      end
     end
  end
end
