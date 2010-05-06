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
		  put :update_password, :user => {:password => 'newpass', :password_confirmation => 'newpass'}, :old_password => @user.password
			assert_redirected_to user_root_path
		end
		should "change with invalid password confirm" do		  
		  put :update_password, :user => {:password => 'newpass', :password_confirmation => 'fail'}, :old_password => @user.password
			assert_response :success
		end
		should "change with invalid old password" do		  
		  put :update_password, :user => {:password => 'newpass', :password_confirmation => 'newpass'}, :old_password => @user.password.reverse
			assert_response :success
		end


	end
end
