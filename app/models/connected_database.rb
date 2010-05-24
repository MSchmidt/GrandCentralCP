class ConnectedDatabase < ActiveRecord::Base
  establish_connection :connected_database
  
  def self.create_database(options={})
    if options[:name]
      connection.execute "CREATE DATABASE `#{options[:name]}`;"
    end
  end
  
  def self.create_user(options={})
    if options[:name] && options[:password]
      connection.execute "CREATE USER '#{options[:name]}'@'localhost' IDENTIFIED BY '#{options[:password]}';"
    end
  end
  
  def self.grant_permission(options={})
    if options[:dbname] && options[:user]
      connection.execute "GRANT SELECT , INSERT , UPDATE , DELETE ON `#{options[:dbname]}`.* TO '#{options[:user]}'@'localhost';"
    end
  end
  
  def self.destroy_database(options={})
    if options[:name]
      connection.execute "DROP DATABASE `#{options[:name]}`;"
    end
  end
  
  def self.destroy_user(options={})
    if options[:name]
      connection.execute "DROP USER '#{options[:name]}'@'localhost';"
    end
  end
  
  def self.change_user_password(options={})
    if options[:name] && options[:password]
      connection.execute "SET PASSWORD FOR '#{options[:name]}'@'localhost' = PASSWORD( '#{options[:password]}' );"
    end
  end
end
