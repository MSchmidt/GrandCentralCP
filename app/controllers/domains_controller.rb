class DomainsController < ApplicationController
  
  before_filter :is_admin, :except => [:index, :show, :edit, :update]
  
  # GET /domains
  # GET /domains.xml
  def index
    if is_admin?
      @domains = Domain.all :include => :user
    else
      @domains = current_user.domains.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @domains }
    end
  end

  # GET /domains/1
  # GET /domains/1.xml
  def show
    if is_admin?
      @domain = Domain.find(params[:id])
    else
      @domain = current_user.domains.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @domain }
    end
  end

  # GET /domains/new
  # GET /domains/new.xml
  # ADMIN only
  def new
    @domain = Domain.new
    @users = User.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @domain }
    end
  end

  # GET /domains/1/edit
  def edit
    if is_admin?
      @domain = Domain.find(params[:id])
      @users = User.all
    else
      @domain = current_user.domains.find(params[:id])
    end
  end

  # POST /domains
  # POST /domains.xml
  # ADMIN only
  def create
    @domain = Domain.new(params[:domain])
    
    respond_to do |format|
      if @domain.save
        #Delayed::Job.enqueue Domain.find(@domain.id)
        flash[:notice] = 'Domain was successfully created.'
        format.html { redirect_to(@domain) }
        format.xml  { render :xml => @domain, :status => :created, :location => @domain }
      else
        @users = User.all
        format.html { render :action => "new" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /domains/1
  # PUT /domains/1.xml
  def update
    if is_admin?
      @domain = Domain.find(params[:id])
    else
      @domain = current_user.domains.find(params[:id])
    end

    respond_to do |format|
      if @domain.update_attributes(params[:domain])
        #Delayed::Job.enqueue Domain.find(@domain.id)
        flash[:notice] = 'Domain was successfully updated.'
        format.html { redirect_to(@domain) }
        format.xml  { head :ok }
      else
        @users = User.all
        format.html { render :action => "edit" }
        format.xml  { render :xml => @domain.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.xml
  # ADMIN only
  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy
    flash[:notice] = 'Domain was successfully destroyed.'

    respond_to do |format|
      format.html { redirect_to(domains_url) }
      format.xml  { head :ok }
    end
  end
end

