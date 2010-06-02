class ConnectedDatabase < ActiveRecord::Base
  establish_connection :connected_database
  
  def self.create_database(options={})
    unless options[:name].blank?
      connection.execute "CREATE DATABASE `#{options[:name]}`;"
    end
  end
  
  def self.create_user(options={})
    unless options[:name].blank? && options[:password].blank?
      connection.execute "CREATE USER '#{options[:name]}'@'localhost' IDENTIFIED BY '#{options[:password]}';"
    end
  end
  
  def self.grant_permission(options={})
    unless options[:dbname].blank? && options[:user].blank?
      connection.execute "GRANT SELECT , INSERT , UPDATE , DELETE ON `#{options[:dbname]}`.* TO '#{options[:user]}'@'localhost';"
    end
  end
  
  def self.destroy_database(options={})
    unless options[:name].blank?
      connection.execute "DROP DATABASE `#{options[:name]}`;"
    end
  end
  
  def self.destroy_user(options={})
    unless options[:name].blank?
      connection.execute "DROP USER '#{options[:name]}'@'localhost';"
    end
  end
  
  def self.change_user_password(options={})
    unless options[:name].blank? && options[:password].blank?
      connection.execute "SET PASSWORD FOR '#{options[:name]}'@'localhost' = PASSWORD( '#{options[:password]}' );"
    end
  end
end
