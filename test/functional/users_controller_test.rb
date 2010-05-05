require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	context "with logged in admin" do
		setup do
			sign_in User.make(:admin => true)
		end

		should "go to users" do
			get :index
			assert_response :success
		end

	end
	
	context "with logged in user" do
		setup do
			sign_in @user = User.make
		end

		should "not go to users" do
			get :index
			assert_response :redirect
		end
		
		should "change password" do
		  put :update, :id => @user.id, :user => {:password => 'newpass'}, :old_password => @user.password, :confirm_password => 'newpass'
			assert_redirected_to domains_path
		end


	end
end
