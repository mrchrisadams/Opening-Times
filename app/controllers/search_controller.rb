class SearchController < ApplicationController
  include Geokit::Geocoders
  include ParserUtils

  DISTANCES = [1, 2, 5, 10, 15, 20, 50]
  DISTANCE_DEFAULT = 15
  NUM_SEARCH_RESULTS = 10

# if no params then render nothing found
# if @t then find group
# if groups then render choose group
# if !groups then render nothing found
# lat, lng = get_from_lat_lat(q)
# find_service by_ lat lng (and group)
# if no services then render nothing found
#

  def index
    @distance = params[:distance].to_i
    @distance = DISTANCE_DEFAULT unless DISTANCES.index(@distance)

    @location = params[:location]
    l_lat, l_lng = extract_lat_lng(@location)
    logger.info "lat=#{l_lat}, lng=#{l_lng}"
    if l_lat && l_lng
      @location = Geokit::LatLng.new(l_lat, l_lng)
    else
      logger.info "geocoding"
      @location = MultiGeocoder.geocode(@location + ", UK")
    end

    @facilities = Facility.find(:all, :origin => @location, :within => @distance, :order => 'distance', :limit => NUM_SEARCH_RESULTS)

    @status_manager = StatusManager.new

    respond_to do |format|
      format.html { render @facilities.empty? ? 'no_results' : 'index' }
      format.xml
      format.json { render :json => @facilities.to_json( :only => [:id,:slug,:name,:location,:address,:postcode,:lat,:lng]), :methods => [:to_param]  }
    end
  end

  def advanced
  end

end
