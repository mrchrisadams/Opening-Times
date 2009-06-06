class FacilitiesController < ApplicationController
  # GET /facilities
  # GET /facilities.xml
  def index
    @facilities = Facility.all
  end

  # GET /facilities/1
  # GET /facilities/1.xml
  def show
    if params[:id].is_integer?
      redirect_to(Facility.find(params[:id]))
    else
      @facility = Facility.find_by_slug(params[:id])
      unless @facility
        render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
      end
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @facility }
      end
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
    @facility = Facility.find_by_slug(params[:id])
    build_spare_openings
  end

  # POST /facilities
  def create
    @facility = Facility.new(params[:facility])

    if @facility.save
      flash[:notice] = 'Facility was successfully created.'
      redirect_to(@facility)
    else
#      build_spare_openings
      render :action => "new"
    end
  end

  # PUT /facilities/1
  def update
    @facility = Facility.find_by_slug(params[:id])

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
