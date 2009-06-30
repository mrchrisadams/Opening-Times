class RevisionsController < ApplicationController

  def index
    @facility = Facility.find(params[:facility_id])
    @revisions = @facility.facility_revisions.find(:all, :order => 'id DESC', :limit => 100)
  end

  def show
    @facility = Facility.find(params[:facility_id])
    @revision = @facility.facility_revisions.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @facility }
      format.json  { render :json => @facility }
    end
  end

end
