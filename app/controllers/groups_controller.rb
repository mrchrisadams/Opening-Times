class GroupsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :sitemap]
  before_filter :check_lockdown, :except => [:index, :show, :sitemap]
  before_filter :check_user, :except => [:index, :show, :sitemap]

  caches_page :index, :show #

  def index
    @groups = Group.connection.select_rows("SELECT count(group_memberships.id) AS count, name, slug FROM groups INNER JOIN group_memberships ON groups.id = group_id GROUP BY name, slug ORDER BY count DESC LIMIT 30")

#    @groups_count = Group.count
#    @group = params[:group]
#    if @group.blank?
#      @group = Group.find_by_name(@group)
#      @members = GroupMembership.paginate(:all, :order=>'ID desc', :page => params[:page])
#      select count(group_memberships.id) as count, name from groups INNER JOIN group_memberships ON groups.id = group_id GROUP BY groups.name order by count;

#    else    
#      @groups = Group.paginate(:all, :conditions => ["name LIKE ?", '%' + @group + '%'], :order=>'name', :page => params[:page])
#    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    group_name = params[:id]
      
    @group = Group.find_by_slug(group_name)

    unless @group
      redirect_to :controller => :search, :group => params[:id] and return  
    end

#    params[:group] = @group.name #set the search field to current group

    @page_desc = "Opening times, branch finder, maps, addresses and contact details for #{@group.name}"

#    @facilities = Facility.find(:all, :select=>'facilities.id, slug, name, location, address, postcode', :joins => 'LEFT OUTER JOIN group_memberships ON facilities.id = facility_id', :conditions => ["group_memberships.group_id=?", @group], :order => "location")

    @facilities = Facility.paginate(:all, :select=>'facilities.id, slug, name, location, address, postcode, lat, lng', :joins => 'LEFT OUTER JOIN group_memberships ON facilities.id = facility_id', :conditions => ["group_memberships.group_id=?", @group], :order => "location", :page => params[:page])

#    @show_az = @facilities.size > 20
  
    @status_manager = StatusManager.new
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find_by_slug(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:success] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find_by_slug(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:success] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
#  def destroy
#    @group = Group.find_by_slug(params[:id])
#    @group.destroy

#    respond_to do |format|
#      format.html { redirect_to(groups_url) }
#      format.xml  { head :ok }
#    end
#  end

  def sitemap
    @groups = Group.paginate(:all, :select => 'slug, updated_at', :page => params[:page], :per_page => SITEMAP_PAGE_SIZE)
  end

end
