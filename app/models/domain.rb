class Domain < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :fqdn
  validates_length_of :fqdn, :minimum => 4
  validates_presence_of :user_id
  
  def save_with_config
    #save
    begin
      servername = self.fqdn
      serveralias = "www." + servername
      email = self.user.email
      folder = self.mount_point
      
      vhost_template = ERB.new(read_vhost_template).result(binding)
      
      Dir.chdir(TARGET_DIR) #definend in config/initializers/gccp.rb
      puts Dir.pwd
      File.open(self.fqdn, "w") do |f|
        f.write(vhost_template)
      end
      #system("etc/init.d/apache2 restart")
    rescue Errno::ENOENT
      puts "No such directory"
    end
  end
  
  def read_vhost_template
    IO.read(TEMPLATE_FILE) #definend in config/initializers/gccp.rb
  end
end
