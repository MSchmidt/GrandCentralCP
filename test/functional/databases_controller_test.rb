require 'test_helper'

class DatabasesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:databases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create database" do
    assert_difference('Database.count') do
      post :create, :database => { }
    end

    assert_redirected_to database_path(assigns(:database))
  end

  test "should show database" do
    get :show, :id => databases(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => databases(:one).to_param
    assert_response :success
  end

  test "should update database" do
    put :update, :id => databases(:one).to_param, :database => { }
    assert_redirected_to database_path(assigns(:database))
  end

  test "should destroy database" do
    assert_difference('Database.count', -1) do
      delete :destroy, :id => databases(:one).to_param
    end

    assert_redirected_to databases_path
  end
end
