require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should "save a new user" do
    User.make
    assert_equal 1, User.count
  end
  
  context "A User instance" do
    setup do
      10.times { User.make }
    end
    
    should_have_many :domains
    should_have_many :databases
    
    should_validate_presence_of :email
    should_validate_uniqueness_of :email
    should_ensure_length_in_range :name, (3..16)
  
    should_not_allow_values_for :email, "blah", "b lah"
    should_allow_values_for :email, "a@b.com", "asdf@asdf.com"
  end
end
