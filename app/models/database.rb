class Database < ActiveRecord::Base
  belongs_to :user
  
  after_create :create_real_database
  after_destroy :destroy_real_database
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 3
  validates_presence_of :user_id
  
  protected
  
  def create_real_database
    ConnectedDatabase::create_database(:name => self.name)
    ConnectedDatabase::create_user(:name => self.user.username, :password => self.user.dbpassword)
    ConnectedDatabase::grant_permission(:dbname => self.name, :user => self.user.username)
  end
    
  def destroy_real_database
    ConnectedDatabase::destroy_database(:name => self.name)
  end
end
