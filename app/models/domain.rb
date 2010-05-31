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
    begin
      servername = self.fqdn
      serveralias = "www." + servername
      email = self.user.email
      path = WWW_DIR + '/' + self.mount_point
      php = self.php
      rails = self.rails
      
      vhost_template = ERB.new(read_template('apache2_vhost.conf')).result(binding)
      index_template = ERB.new(read_template('index.html')).result(binding)
      
      Dir.chdir(VHOST_TARGET_DIR) #definend in config/initializers/gccp.rb
      
      File.open('gccp_' + servername, "w") do |f|
        f.write(vhost_template)
      end
      system("a2ensite gccp_#{servername}")
      system("/etc/init.d/apache2 reload")
      
      Dir.mkdir(WWW_DIR + folder)
      Dir.chdir(WWW_DIR + folder)
      
      if rails
        #adduser deploy
        #gem install mongrel_cluster
        #a2enmod rewrite
        #a2enmod proxy
        #a2enmod proxy_http
        #a2enmod proxy_balancer
        system("chown deploy:deploy #{WWW_DIR + folder}")
        system("mkdir -p current/public")
        system("echo 'hello world' > current/public/index.html")
        Dir.mkdir("/etc/mongrel_cluster")
        system("chown deploy:deploy /etc/mongrel_cluster")
      end
      
      indexfile = "index.html"
      indexfile = "index.php" if php
      
      File.open(indexfile, "w") do |f|
        f.write(index_template)
      end
      
    rescue Errno::ENOENT
      puts "No such directory"
    end
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
        
        system("a2dissite gccp_#{servername}")
        
        Dir.chdir(VHOST_TARGET_DIR) #definend in config/initializers/gccp.rb
        File.delete('gccp_' + servername) if File.exist?('gccp_'+servername)
        system("rm -rf #{WWW_DIR + folder}")
        
        system("/etc/init.d/apache2 reload")
        
      rescue Errno::ENOENT
        puts "No such directory"
      end
     end
  end
end
