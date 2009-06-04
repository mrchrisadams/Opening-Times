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
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404 unless @facility
    end
  end

  # GET /facilities/new
  def new
    @facility = Facility.new
  end

  # GET /facilities/1/edit
  def edit
    @facility = Facility.find_by_slug(params[:id])
  end

  # POST /facilities
  def create
    @facility = Facility.new(params[:facility])

    if @facility.save
      flash[:notice] = 'Facility was successfully created.'
      redirect_to(@facility)
    else
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
      render :action => "edit"
    end
  end

  # DELETE /facilities/1
  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy

    redirect_to(facilities_url)
  end
end
