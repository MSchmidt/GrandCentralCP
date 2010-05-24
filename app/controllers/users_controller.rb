class UsersController < ApplicationController
  
  before_filter :is_admin, :except => [:change_password, :update_password, :update_db_password]
  
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save 
        Delayed::Job.enqueue User.find(@user.id)
        flash[:notice] = "User was successfully created. Please save the password: #{@user.password}"
        format.html { redirect_to(users_url) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        if params[:user][:password] && params[:user][:password].any?
          flash[:notice] = "User was successfully updated. Please save the new password: #{@user.password}"
        else
          flash[:notice] = "User was successfully updated."
        end
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def change_password
    @user = current_user
  end
  
  def update_password
    @user = current_user
    
    respond_to do |format|
      if @user.valid_password?(params[:old_password]) && (params[:user][:password] == params[:user][:password_confirmation]) && params[:user][:password].any? && @user.update_attribute(:password, params[:user][:password])
        flash[:notice] = 'User Password was successfully changed.'
        format.html { redirect_to(user_root_url) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Confirmation Password or Old Password wrong'
        format.html { render :action => "change_password" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update_db_password
    @user = current_user

    respond_to do |format|
      if @user.update_attribute(:dbpassword, params[:user][:dbpassword])
        ConnectedDatabase::change_user_password(:name => @user.name, :password => @user.dbpassword)
        flash[:notice] = 'User DB Password was successfully changed.'
        format.html { redirect_to(databases_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "change_password" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    system("userdel #{@user.name}") if @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
