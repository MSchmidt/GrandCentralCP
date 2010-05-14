class Database < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 3
  validates_presence_of :user_id
  
  def perform
    write_config
  end
  
  def write_config
    dbname = self.name
    user = self.user.email
    userpwd = self.user.dbpassword
    
    ConnectedDatabase::create_database(:name => dbname)
    ConnectedDatabase::create_user(:name => user, :password => userpwd)
    ConnectedDatabase::grant_permission(:dbname => dbname, :user => user)
  end
  
  def destroy_db
    dbname = self.name
    
    ConnectedDatabase::destroy_database(:name => dbname)
  end
end
