require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  should "save a new database" do
    Database.make
    assert_equal 1, Database.count
  end
  
  context "A Database instance" do
    setup do
      10.times { Database.make }
    end
    
    should_belong_to :user
    
    should_validate_presence_of :name
    should_validate_uniqueness_of :name
    should_ensure_length_at_least :name, 3
    should_validate_presence_of :user_id
  end
end
