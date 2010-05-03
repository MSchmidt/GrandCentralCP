class Database < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :minimum => 3
  validates_presence_of :user_id
end
