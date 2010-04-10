class User < ActiveRecord::Base
  devise :authenticatable
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :email
end
