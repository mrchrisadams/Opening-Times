class FacilitiesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :redirect_id_to_slug, :only => [:show]
  before_filter :redirect_slug_to_id, :except => [:index, :show]

  def index
    @facilities = Facility.find(:all, :order => 'updated_at DESC', :limit => 100)
  end

  def show
    #TODO Find slug and find ID from that
    @facility = Facility.find_by_slug(params[:id])
    unless @facility
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404 and return
    end
    @status_manager = StatusManager.new
    @status = @status_manager.status(@facility)
    respond_to do |format|
      format.html {
        @nearby = Facility.find(:all, :conditions => ["id <> ?",@facility.id], :origin => @facility, :within => 20, :order => 'distance', :limit => 20)
      }# show.html.html
      format.xml  { render :xml => @facility }
      format.json  { render :json => @facility }
    end
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
#    @facility.normal_openings.build(:week_day=>"Wed")
#    @facility.normal_openings.build(:week_day=>"Fri")
    build_spare_openings
  end

  # GET /facilities/1/edit
  def edit
    @facility = Facility.find(params[:id])
    build_spare_openings
  end

  # POST /facilities
  def create
    @facility = Facility.new(params[:facility])

    if @facility.save
      flash[:notice] = 'Facility was successfully created.'
      redirect_to(@facility)
    else
      build_spare_openings
      render :action => "new"
    end
  end

  # PUT /facilities/1
  def update
    @facility = Facility.find(params[:id])

    if @facility.update_attributes(params[:facility])
      flash[:notice] = 'Facility was successfully updated.'
      redirect_to(@facility)
    else
      build_spare_openings
      render :action => "edit"
    end
  end

  # DELETE /facilities/1
  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy

    redirect_to(facilities_url)
  end


  private

    def redirect_id_to_slug
      id = params[:id]
      if id.is_integer? && f = Facility.find(id)
        redirect_to(f) and return
      end
    end

    def redirect_slug_to_id
      id = params[:id]
      if !id.is_integer? && f = Facility.find_by_slug(id)
        redirect_to(:action => params[:action], :id => f.id) and return
      end
    end

    def build_spare_openings
      if @facility.normal_openings.empty?
        for day in Opening::DAYNAMES
          @facility.normal_openings.build(:week_day=>day)
        end
      end
      if @facility.normal_openings.size < 7
        next_day = (@facility.normal_openings.last.wday + 1) % 7
        @facility.normal_openings.build(:wday=> next_day)
      end

#      facility.holiday_openings.build(:closed=>true) if facility.holiday_openings.size.zero?
#      if facility.special_openings.size.zero?
#        3.times { facility.special_openings.build }
#      else
#        facility.special_openings.build
#      end
    end

end
