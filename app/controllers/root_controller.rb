class RootController < ApplicationController

  def sitemap
    @facilities = Facility.all
  end

  def bankholidays
    @holiday_sets = HolidaySet.find(:all, :include=>:holiday_events)
    respond_to do |format|
      format.xml { render :xml => @holiday_sets.to_xml( :include=>:holiday_events ) }
      format.json { render :json => @holiday_sets.to_json( :include=>:holiday_events ) }
      format.html
    end

  end

  def statistics
    @total_facilities = Facility.count
    @new_facilities_today = Facility.count(:id, :conditions => ["created_at > ?", Date.today])

    @total_users = User.count
    @new_users_today = User.count(:id, :conditions => ["created_at > ?", Date.today])
  end

end
