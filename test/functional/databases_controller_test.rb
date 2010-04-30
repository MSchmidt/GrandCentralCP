require 'test_helper'

class DatabasesControllerTest < ActionController::TestCase
	context "with logged in admin" do
		setup do
			sign_in @user = User.make(:admin => true)
      @database = Database.make(:user_id => @user.id)
		end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:databases)
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create database" do
      assert_difference('Database.count') do
        post :create, :database => {:name => 'blaaa', :user_id => @user.id}
      end

      assert_redirected_to database_path(assigns(:database))
    end

    should "show database" do
      get :show, :id => @database.id
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => @database.id
      assert_response :success
    end

    should "update database" do
      put :update, :id => @database.id, :database => {:name => 'newname', :user_id => @user.id}
      assert_redirected_to database_path(assigns(:database))
    end

    should "destroy database" do
      assert_difference('Database.count', -1) do
        delete :destroy, :id => @database.id
      end

      assert_redirected_to databases_path
    end
  end
  
  context "with logged in customer" do
		setup do
			sign_in @user = User.make
      @database = Database.make
		end

    should "create database" do
      #assert_response :redirect
    end

    should "get edit" do
      get :edit, :id => @database.id
      assert_response :success
    end
  end
end
