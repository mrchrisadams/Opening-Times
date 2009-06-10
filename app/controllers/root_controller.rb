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


end
