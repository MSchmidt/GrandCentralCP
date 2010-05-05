class DatabasesController < ApplicationController
  # GET /databases
  # GET /databases.xml
  def index
    if is_admin?
      @databases = Database.all
    else
      @databases = Database.find(:all, :conditions => {:user_id => current_user.id})
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @databases }
    end
  end

  # GET /databases/1
  # GET /databases/1.xml
  def show
    @database = Database.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @database }
    end
  end

  # GET /databases/new
  # GET /databases/new.xml
  def new
    @database = Database.new
    @users = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @database }
    end
  end

  # GET /databases/1/edit
  def edit
    @database = Database.find(params[:id])
    @users = User.all
  end

  # POST /databases
  # POST /databases.xml
  def create
    @database = Database.new(params[:database])

    respond_to do |format|
      if @database.save
        Delayed::Job.enqueue Database.find(@database.id)
        flash[:notice] = 'Database was successfully created.'
        format.html { redirect_to(@database) }
        format.xml  { render :xml => @database, :status => :created, :location => @database }
      else
        @users = User.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @database.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /databases/1
  # PUT /databases/1.xml
  def update
    @database = Database.find(params[:id])

    respond_to do |format|
      if @database.update_attributes(params[:database])
        flash[:notice] = 'Database was successfully updated.'
        format.html { redirect_to(@database) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @database.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /databases/1
  # DELETE /databases/1.xml
  def destroy
    @database = Database.find(params[:id])
    @database.destroy

    respond_to do |format|
      format.html { redirect_to(databases_url) }
      format.xml  { head :ok }
    end
  end
end
