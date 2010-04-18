class User < ActiveRecord::Base

  devise :authenticatable
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :email, :password
  
  def before_validation
    if !self.password
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(8) { |i| newpass << chars[rand(chars.size-1)] }
      self.password = newpass
    end
  end

end
