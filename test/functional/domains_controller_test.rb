require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
	context "with logged in admin" do
		setup do
			sign_in @user = User.make(:admin => true)
      @domain = Domain.make(:user_id => @user.id)
		end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:domains)
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "create domain" do
      assert_difference('Domain.count') do
        assert_difference('Delayed::Job.count') do
          post :create, :domain => {:fqdn => 'bla.com', :user_id => @user.id, :mount_point => '/bla'}
        end
      end
      
      assert_redirected_to domain_path(assigns(:domain))
    end
    
    should "show domain" do
      get :show, :id => @domain.id
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => @domain.id
      assert_response :success
    end

    should "update domain" do
      assert_difference('Delayed::Job.count') do
        put :update, :id => @domain.id, :domain => {:fqdn => 'new.com', :user_id => @user.id, :mount_point => '/new'}
      end
      
      assert_redirected_to domain_path(assigns(:domain))
    end

    should "destroy domain" do
      assert_difference('Domain.count', -1) do
        delete :destroy, :id => @domain.id
      end

      assert_redirected_to domains_path
    end
  end
  
  context "with logged in customer" do
		setup do
			sign_in @user = User.make
      @domain = Domain.make
		end

    should "get edit" do
      get :edit, :id => @domain.id
      assert_response :success
    end
  end
end
