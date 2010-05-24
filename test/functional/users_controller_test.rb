require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	context "Logged in admin" do
		setup do
			sign_in @admin = User.make(:admin => true)
			@user = User.make
		end

		should "get index" do
			get :index
			assert_not_nil assigns(:users)
			assert_response :success
		end
		
		should "get new" do
			get :new
			assert_response :success
		end
		
		should "create user" do
		  assert_difference('User.count') do
		    assert_difference('Delayed::Job.count') do
		      post :create, :user => User.plan
		    end
	    end
	    
	    assert_redirected_to users_url
	  end
		
		should "get show" do
			get :show, :id => @user.id
			assert_not_nil assigns(:user)
			assert_response :success
		end
		
		should "get edit" do
			get :edit, :id => @user.id
			assert_response :success
		end
		
		should "update user" do		  
		  put :update, :id => @user.id, :user => {:email => 'new@email.com'}
		  assert_redirected_to user_url(assigns(:user))
		end
		
		should "destroy user" do
		  assert_difference('User.count', -1) do
        delete :destroy, :id => @user.id
      end
      
      assert_redirected_to users_url
	  end
	end
	
	context "Logged in user" do
		setup do
			sign_in @user = User.make
		end

		should "redirect on GET to index" do
			get :index
			assert_redirected_to user_root_url
		end
		
		should "redirect on GET to new" do
			get :new
			assert_redirected_to user_root_url
		end
		
		should "redirect on POST to create" do
			post :create
			assert_redirected_to user_root_url
		end
		
		should "redirect on GET to show" do
			get :show
			assert_redirected_to user_root_url
		end
		
		should "redirect on GET to edit" do
			get :edit
			assert_redirected_to user_root_url
		end
		
		should "redirect on PUT to update" do
			put :update
			assert_redirected_to user_root_url
		end
		
		should "redirect on DELETE to destroy" do
			delete :destroy
			assert_redirected_to user_root_url
		end
		
		should "get change_password" do
			get :change_password
			assert_response :success
		end
		
		should "update password" do		  
		  put :update_password, :user => { :password => 'newpass', :password_confirmation => 'newpass' }, :old_password => @user.password
			assert_redirected_to user_root_url
		end
		
		should "flash on PUT to update_password with invalid confirmation password" do		  
		  put :update_password, :user => { :password => 'newpass', :password_confirmation => 'fail' }, :old_password => @user.password
			assert_response :success
			assert_equal 'Confirmation Password or Old Password wrong', flash[:notice]
		end
		
		should "flash on PUT to update_password with invalid old password" do		  
		  put :update_password, :user => { :password => 'newpass', :password_confirmation => 'newpass' }, :old_password => @user.password.reverse
			assert_response :success
			assert_equal 'Confirmation Password or Old Password wrong', flash[:notice]
		end
		
		should "update db_password" do
		  #ConnectedDatabase::grant_permission(:dbname => "*", :user => @user.name)
      #ConnectedDatabase::destroy_user(:name => @user.name)
		  #ConnectedDatabase::create_user(:name => @user.name, :password => @user.dbpassword)
		  put :update_db_password, :user => { :dbpassword => 'newDBpassword' }
		  assert_redirected_to databases_url
		  assert_equal 'User DB Password was successfully changed.', flash[:notice]
	  end
	end
end
