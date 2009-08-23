class AboutController < ApplicationController

  def bankholidays
    @holiday_sets = HolidaySet.all
    respond_to do |format|
      format.xml { render :xml => @holiday_sets.to_xml( :include=>:holiday_events ) }
      format.json { render :json => @holiday_sets.to_json( :include=>:holiday_events ) }
      format.html
    end

  end

  def recentchanges
    @revisions = FacilityRevision.find(:all, :order => 'id DESC', :limit => 100)
    respond_to do |format|
      format.html
      format.xml #TODO format this as ATOM
      format.rss { redirect_to :format => :xml }
    end
  end

  def recentlyremoved
    @removed = Facility.find(:all, :conditions => "retired_at IS NOT NULL", :order => 'id DESC', :limit => 100)
    respond_to do |format|
      format.html
      format.xml #TODO format this as ATOM
      format.rss { redirect_to :format => :xml }
    end
  end

  def register
    redirect_to signup_path
  end

  def sitemap
    @facilities = Facility.all
  end

  def statistics
    @total_facilities = Facility.count
    @new_facilities_today = Facility.count(:id, :conditions => ["created_at > ?", Date.today])

    @total_users = User.count
    @new_users_today = User.count(:id, :conditions => ["created_at > ?", Date.today])
  end

end

