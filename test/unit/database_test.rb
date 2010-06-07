require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  
  context "database model" do
    setup do
      @user = User.make
      @db = Database.make_unsaved(:user_id => @user.id, :name => @user.username)
    end
      
    should "save a new database" do
      assert @db.save
      assert_equal 1, Database.count
      assert_equal 1, ConnectedDatabase::connection.execute("SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '#{@db.name}';").fetch_row[0].to_i
    end
    
    should "destroy a database" do
      @db = Database.make(:user_id => @user.id, :name => @user.username)
      assert @db.destroy
      assert_equal 0, Database.count
      assert_equal 0, ConnectedDatabase::connection.execute("SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '#{@db.name}';").fetch_row[0].to_i
    end
  
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
