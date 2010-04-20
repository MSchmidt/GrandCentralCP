class Domain < ActiveRecord::Base
  def save_with_config
    #save
    begin
      servername = "mysite.com"
      serveralias = "www." + servername
      
      vhost_template = read_vhost_template
      
      vhost_template.gsub! '%servername%', servername
      vhost_template.gsub! '%serveralias%', serveralias
      puts vhost_template
      
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
