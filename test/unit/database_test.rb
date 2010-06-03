require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  #ActiveRecord::Base.establish_connection :connected_database
  
  should "save a new database" do
    @user = User.make
    @db = Database.make(:user_id => @user.id)
    assert_equal 1, Database.count
    puts @db.name
    #res = connection.execute("SELECT COUNT(*) FROM #{@db.name};")
    #row = res.fetch_row

    #puts row[0].to_s
  end
  
  context "A Database instance" do
    setup do
      @user = User.make
      10.times { Database.make(:user_id => @user.id) }
    end
    
    should_belong_to :user
    
    should_validate_presence_of :name
    should_validate_uniqueness_of :name
    should_ensure_length_at_least :name, 3
    should_validate_presence_of :user_id
  end
end
