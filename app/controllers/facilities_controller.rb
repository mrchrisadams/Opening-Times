class FacilitiesController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :sitemap]
  before_filter :check_lockdown, :except => [:index, :show, :sitemap]
  before_filter :check_user, :except => [:index, :show, :sitemap]
  before_filter :redirect_id_to_slug, :only => [:show]

  def index
    page = params[:page].to_i
    page = 1 unless page > 0
    @status_manager = StatusManager.new
    @facilities = Facility.paginate(:all, :conditions => 'retired_at IS NULL', :order => 'location', :page => page)
  end

  # GET /facilities/new
  def new
    @facility = Facility.new

    revision = Facility.find(params[:f]).facility_revisions.last.id rescue nil
    revision = params[:r].to_i unless revision
    if revision > 0
      revision = FacilityRevision.find(revision)
      @facility.from_xml(revision.xml)
      @facility.comment = ""
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
    @facility.retired = 0
    @facility.comment = ""

    build_spare_openings
  end

  # POST /facilities
  def create
    @facility = Facility.new(params[:facility])
    update_user_info

#    begin
      if @facility.save
        flash[:success] = 'Business was successfully created.'
        redirect_to(@facility)
      else
        build_spare_openings
        render "new"
      end
#    rescue
#      # See note in Facility after_save
#      @facility.errors.add_to_base("One or more openings overlap or you have a closed and open session on the same day.")
#      build_spare_openings
#      render "new"
#    end
  end

  # PUT /facilities/1
  def update
    @facility = Facility.find(params[:id])
    update_user_info

    if @facility.update_attributes(params[:facility])
      flash[:success] = 'Business was successfully updated.'
      redirect_to(@facility)
    else
      build_spare_openings
      render :action => "edit"
    end
  end

  def remove
    @facility = Facility.find(params[:id])
    @facility.comment = "" unless @facility.retired?
  end

  # DELETE /facilities/1
#  def destroy
#    @facility = Facility.find(params[:id])

#    redirect_to(facilities_url)
#  end

  def sitemap
    @facilities = Facility.paginate(:all, :select => 'slug, updated_at', :page => params[:page], :per_page => SITEMAP_PAGE_SIZE)
  end

  private

    def redirect_id_to_slug
      id = params[:id]
            
      if !id.blank?
        if f = Facility.find_by_id(id)
          return redirect_to(facility_slug_path(f.slug))
        elsif f = Facility.find_by_slug(id)
          return redirect_to(facility_slug_path(f.slug))
        end
      end
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    def build_spare_openings

      if @facility.new_record?
        @facility.normal_openings.each { |x| x.id = nil }
        @facility.holiday_openings.each { |x| x.id = nil }
      end

      if @facility.normal_openings.empty?
        for day in Opening::DAYNAMES
          @facility.normal_openings.build(:week_day=>day)
        end
      else
        next_day = (@facility.normal_openings.last.wday + 1) % 7
        @facility.normal_openings.build(:wday=> next_day)
      end
      @facility.holiday_openings.build if @facility.holiday_openings.empty?
    end

    def update_user_info
      @facility.user = current_user
      @facility.updated_from_ip = current_user.current_login_ip
    end

end

