class Domain < ActiveRecord::Base
  belongs_to :user
  
  validates_length_of :domain, :minimum => 4
  validates_presence_of :user_id
  validates_uniqueness_of :domain
  
  def save_with_config
    #save
    begin
      servername = "mysite.com"
      serveralias = "www." + servername
      
      vhost_template = ERB.new(read_vhost_template).result(binding)
      
      Dir.chdir(TARGET_DIR) #definend in config\initializers\paths.rb
      puts Dir.pwd
      File.open("domain.txt", "w") do |f|
        f.write(vhost_template)
      end
    rescue Errno::ENOENT
      puts "No such directory"
    end
  end
  
  def read_vhost_template
    IO.read(TEMPLATE_FILE) #definend in config\initializers\paths.rb
  end
end
