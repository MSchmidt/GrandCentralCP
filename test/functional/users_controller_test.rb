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
			sign_in User.make
		end

		should "go to users" do
			get :index
			assert_response :redirect
		end

	end
end
