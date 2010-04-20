require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	context "with logged in admin" do
		setup do
			sign_in User.make(:admin => true)
		end

		should "go to customers" do
			get :index
			assert_response :success
		end

	end
	
	
	context "with logged in customer" do
		setup do
			sign_in User.make
		end

		should "go to customers" do
			get :index
			assert_redirected_to domains_url
		end

	end
end
