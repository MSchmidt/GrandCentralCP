require 'test_helper'

class UserSessionsTest < ActionController::IntegrationTest
  
  context "A customer" do
		setup do
			@user = User.make
		end

		should "log into GCCP" do
      visit root_path
      fill_in "user[email]", :with => @user.email
      fill_in "user[password]", :with => @user.password
      click_button "Sign in!"
      assert_contain 'Signed in successfully.'
		end
		
    should "log in and log out" do
      visit root_path
      fill_in "user[email]", :with => @user.email
      fill_in "user[password]", :with => @user.password
      click_button "Sign in!"
      assert_contain 'Signed in successfully.'
      
      click_link 'logout'
      assert_contain 'Signed out successfully.'
    end

	end
	
  
end
