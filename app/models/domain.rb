class Domain < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :fqdn, :mount_point
  validates_uniqueness_of :fqdn
  validates_length_of :fqdn, :minimum => 4
  validates_presence_of :user_id
  
  def save_with_config
    save
    
    begin
      servername = self.fqdn
      serveralias = "www." + servername
      email = self.user.email
      folder = self.mount_point
      
      vhost_template = ERB.new(read_template('apache2_vhost.conf')).result(binding)
      index_template = ERB.new(read_template('index.html')).result(binding)
      
      Dir.chdir(VHOST_TARGET_DIR) #definend in config/initializers/gccp.rb
      puts Dir.pwd
      #File.open('gccp_' + servername, "w") do |f|
      File.open(servername, "w") do |f|
        f.write(vhost_template)
      end
      system("a2ensite #{servername}")
      system("etc/init.d/apache2 reload")
      #system("etc/init.d/apache2 restart")
      
      Dir.mkdir(WWW_DIR+folder)
      Dir.chdir(WWW_DIR+folder)
      File.open("index.html", "w") do |f|
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
    destroy
    
    begin
      servername = self.fqdn
      folder = self.mount_point
      
      system("a2dissite #{servername}")
      Dir.rmdir(WWW_DIR+folder)
      system("etc/init.d/apache2 reload")
      
      Dir.chdir(VHOST_TARGET_DIR) #definend in config/initializers/gccp.rb
      File.delete(servername) if File.exist?
      
    rescue Errno::ENOENT
      puts "No such directory"
    end
  end
end
