class ViewdatesController < ApplicationController
  
    before_filter :check_administrator_role
  # GET /viewdates
  # GET /viewdates.xml
  def index
    @viewdates = Viewdate.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @viewdates }
    end
  end

  # GET /viewdates/1
  # GET /viewdates/1.xml
  def show
    @viewdate = Viewdate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @viewdate }
    end
  end

  # GET /viewdates/new
  # GET /viewdates/new.xml
  def new
    @viewdate = Viewdate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @viewdate }
    end
  end

  # GET /viewdates/1/edit
  def edit
    @viewdate = Viewdate.find(params[:id])
  end

  # POST /viewdates
  # POST /viewdates.xml
  def create
    @viewdate = Viewdate.new(params[:viewdate])

    respond_to do |format|
      if @viewdate.save
        flash[:notice] = 'Viewdate was successfully created.'
        format.html { redirect_to(@viewdate) }
        format.xml  { render :xml => @viewdate, :status => :created, :location => @viewdate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @viewdate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /viewdates/1
  # PUT /viewdates/1.xml
  def update
    @viewdate = Viewdate.find(params[:id])

    respond_to do |format|
      if @viewdate.update_attributes(params[:viewdate])
        flash[:notice] = 'Viewdate was successfully updated.'
        format.html { redirect_to(@viewdate) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @viewdate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /viewdates/1
  # DELETE /viewdates/1.xml
  def destroy
    @viewdate = Viewdate.find(params[:id])
    @viewdate.destroy

    respond_to do |format|
      format.html { redirect_to(viewdates_url) }
      format.xml  { head :ok }
    end
  end
end
