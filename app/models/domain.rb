class Domain < ActiveRecord::Base
  belongs_to :user
  
  def save_with_config
    #save
    begin
      servername = "mysite.com"
      serveralias = "www." + servername
      
      vhost_template = ERB.new(read_vhost_template).result(binding)
      
      target_dir = "/Applications/XAMPP/htdocs/ror/GrandCentralCP_testenv/apache2/sites-available"
      Dir.chdir(target_dir)
      puts Dir.pwd
      File.open("domain.txt", "w") do |f|
        f.write(vhost_template)
      end
    rescue Errno::ENOENT
      puts "No such directory"
    end
  end
  
  def read_vhost_template
    template_file = RAILS_ROOT + '/app/templates/apache2_vhost.conf'
    IO.read(template_file)
  end
end
