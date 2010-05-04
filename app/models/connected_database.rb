class ConnectedDatabase < ActiveRecord::Base
  establish_connection :connected_database
   
  def self.create_database(options={})
    if options[:name] && options[:name].any?
      connection.execute "CREATE DATABASE `#{options[:name]}`;"
    end
  end
  
  def self.create_user(options={})
    if options[:name] && options[:password] && options[:name].any? && options[:password].any?
      connection.execute "CREATE USER '#{options[:name]}'@'localhost' IDENTIFIED BY '#{options[:password]}';"
    end
  end
  
  def self.grant_permission(options={})
    if options[:dbname] && options[:user] && options[:dbname].any? && options[:user].any?
      connection.execute "GRANT SELECT , INSERT , UPDATE , DELETE ON `#{options[:dbname]}`.* TO '#{options[:user]}'@'localhost';"
    end
  end
  
  def self.destroy_database(options={})
    if options[:name] && options[:name].any?
      connection.execute "DROP DATABASE `#{options[:name]}`;"
    end
  end
  
  def self.destroy_user(options={})
    if options[:name] && options[:name].any?
      connection.execute "DROP USER '#{options[:name]}'@'localhost';"
    end
  end
  
end
