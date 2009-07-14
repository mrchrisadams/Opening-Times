class FacilitiesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :redirect_id_to_slug, :only => [:show]

  def index
    @facilities = Facility.find(:all, :order => 'updated_at DESC', :limit => 100)
  end

  # GET /facilities/new
  def new
    @facility = Facility.new

    if params[:r]
      revision = FacilityRevision.find(params[:r])
      @facility.from_xml(revision.xml)
      @facility.address.gsub!(', ',"\n")
    end
    build_spare_openings
  end

  # GET /facilities/1/edit
  def edit
    @facility = Facility.find(params[:id])

    if params[:r]
      revision = FacilityRevision.find(params[:r])
      @facility.normal_openings = []
      @facility.from_xml(revision.xml)
    end

    @facility.address.gsub!(', ',"\n")

    build_spare_openings
  end

  # POST /facilities
  def create
    @facility = Facility.new(params[:facility])
    @facility.created_by = @facility.updated_by = current_user.id

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
    @facility.updated_by = current_user.id

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
    @facility.retire

    redirect_to(facilities_url)
  end


  private

    def redirect_id_to_slug
      id = params[:id]
      if params[:format].blank? && id.is_integer? && f = Facility.find(id)
        redirect_to(facility_slug_path(f.slug)) and return
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
