class IpController < ApplicationController

  def index
    @revisions = FacilityRevision.find(:all, :conditions => ["ip = ?", params[:ip]], :limit => 100)
  end

end

