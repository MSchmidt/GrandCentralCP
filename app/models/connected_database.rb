class ConnectedDatabase < ActiveRecord::Base
  establish_connection :connected_database
  
  def self.create_database(options={})
    unless options[:name].blank?
      connection.execute "CREATE DATABASE IF NOT EXISTS `#{options[:name]}`;"
    end
  end
  
  def self.create_user(options={})
    unless options[:name].blank? && options[:password].blank?
      res = connection.execute("SELECT COUNT(*) FROM user WHERE User = '#{options[:name]}';")
      row = res.fetch_row
      if row[0].to_i < 1
        connection.execute "CREATE USER '#{options[:name]}'@'localhost' IDENTIFIED BY '#{options[:password]}';"
      end
    end
  end
  
  def self.grant_permission(options={})
    unless options[:dbname].blank? && options[:user].blank?
      connection.execute "GRANT SELECT , INSERT , UPDATE , DELETE ON `#{options[:dbname]}`.* TO '#{options[:user]}'@'localhost';"
    end
  end
  
  def self.destroy_database(options={})
    unless options[:name].blank?
      connection.execute "DROP DATABASE IF EXISTS `#{options[:name]}`;"
    end
  end
  
  def self.change_user_password(options={})
    unless options[:name].blank? && options[:password].blank?
      res = connection.execute("SELECT COUNT(*) FROM user WHERE User = '#{options[:name]}';")
      row = res.fetch_row

      if row[0].to_i > 0
        connection.execute "SET PASSWORD FOR '#{options[:name]}'@'localhost' = PASSWORD( '#{options[:password]}' );"
      end
    end
  end
  
  def self.rename_user(options={})
    unless options[:name].blank? && options[:oldname].blank?
      res = connection.execute("SELECT COUNT(*) FROM user WHERE User = '#{options[:oldname]}';")
      row = res.fetch_row
      
      if row[0].to_i > 0
        connection.execute "RENAME USER '#{options[:oldname]}'@'localhost' TO '#{options[:name]}'@'localhost';"
        connection.execute "FLUSH PRIVILEGES;"
      end
    end
  end
  
  def self.destroy_user(options={})
    unless options[:name].blank?
      res = connection.execute("SELECT COUNT(*) FROM user WHERE User = '#{options[:name]}';")
      row = res.fetch_row

      if row[0].to_i > 0
        connection.execute "DROP USER '#{options[:name]}'@'localhost';"
      end
    end
  end
end
