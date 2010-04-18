require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should "save a new user" do
    User.make
    assert_equal 1, User.count
  end
end
