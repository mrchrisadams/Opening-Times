class RevisionsController < ApplicationController

  def index
    @revision_limit = 100
    @facility = Facility.find(params[:facility_id])
#    @revisions = @facility.facility_revisions.find(:all, :order => 'id DESC', :limit => 100)
    @revisions = FacilityRevision.find_all_by_facility_id(@facility, :order => 'id DESC', :limit => 100)
    respond_to do |format|
      format.html
      format.xml
    end
  end

  def show
    @facility = Facility.find(params[:facility_id])
    @revision = @facility.facility_revisions.find(params[:id])
    render :xml => @revision
  end

end
