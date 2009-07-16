class SlugTrapController < ApplicationController

  def show
    #TODO Find slug and find ID from that
    @facility = Facility.find_by_slug(params[:slug])

    return redirect_slug_or_404(params[:id]) unless @facility

    @status_manager = StatusManager.new
    @status = @status_manager.status(@facility)
    respond_to do |format|
      format.html do
        @nearby = Facility.find(:all, :conditions => ["id <> ?",@facility.id], :origin => @facility, :within => 20, :order => 'distance', :limit => 20)
        render 'facilities/show'
      end
      format.xml  { render :xml => @facility }
      format.json  { render :json => @facility }
    end
  end

  private

  def redirect_slug_or_404(slug)
    trap = SlugTrapFacility.find_by_slug(params[:slug])
    if trap
      redirect_to(facility_slug_path(:slug => trap.redirect_slug), :status=>301)
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    end
  end


end
