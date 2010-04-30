class Database < ActiveRecord::Base
  belongs_to :user
  
  validates_length_of :name, :minimum => 3
  validates_presence_of :user_id
  validates_uniqueness_of :name
end
