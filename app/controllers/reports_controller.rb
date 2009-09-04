class ReportsController < ApplicationController

  DEFAULT_LIMIT = 100
  MAX_LIMIT = 1000

  before_filter :set_limit

  def filter
    conditions = []
    arguments = {}
    
    unless (@min_opens_at = params[:min_opens_at]).blank?
      conditions << "opens_mins >= :min_opens_at"
      arguments[:min_opens_at] = time_to_mins(@min_opens_at)
    end
    
    unless params[:max_opens_at].blank?
      conditions << "opens_mins <= :max_opens_at"
      arguments[:max_opens_at] = time_to_mins(params[:max_opens_at])
    end
    
    all_conditions = conditions.join(' AND ')
    @woo = [all_conditions, arguments].inspect

    @openings = NormalOpening.paginate(:all, :include => :facility, :conditions => [all_conditions, arguments], :page => params[:page])
  end

  def long_locations
    @facilities = Facility.paginate(:all, :order => 'LENGTH(location) DESC', :page => params[:page])
  end

  def noon_openings
    @openings = NormalOpening.paginate(:all, :include => :facility, :conditions => "opens_mins = 720", :page => params[:page])
  end

  def noon
    conditions = []
    arguments = {}

    @end = params[:end] 
    case @end
      when "opens"
        conditions << "opens_mins = 720"
      when "closes"
        conditions << "closes_mins = 720"      
      else
        conditions << "opens_mins = 720 OR closes_mins = 720"
    end

    @week_day = params[:week_day] 
    unless @week_day.blank?
      @week_day = @week_day.to_i
      conditions << "sequence = :sequence"
      arguments[:sequence] = @week_day
    end
    
    all_conditions = conditions.join(' AND ')
  
    @openings = NormalOpening.paginate(:all, :include => :facility, :conditions => [all_conditions, arguments], :page => params[:page])
  end

  def openings_count
    @min = (params[:min] || 7).to_i
    @max = (params[:max] || 7).to_i
    @max = @min if @min > @max
    @facilities = Facility.find_by_sql("SELECT facilities.id, name, location, updated_at, count(openings.id) AS openings_count FROM facilities LEFT JOIN openings ON facilities.id = facility_id GROUP BY facilities.id HAVING openings_count < #{@min} or openings_count > #{@max} ORDER BY updated_at DESC LIMIT #{@limit}")
  end

  def openings_length
    @min = params[:min] 
    @min = @min ? @min.to_i : 0
    @max = params[:max]
    @max = @max ? @max.to_i : 24 * 60
    @max = @min if @min > @max

    conditions = ["(closes_mins - opens_mins) BETWEEN :min AND :max"]
    arguments = {}
    arguments[:min] = @min
    arguments[:max] = @max
       
    @week_day = params[:week_day] 
    unless @week_day.blank?
      @week_day = @week_day.to_i
      conditions << "sequence = :sequence"
      arguments[:sequence] = @week_day
    end
    
    all_conditions = conditions.join(' AND ')
    
    @openings = Opening.paginate(:all, :include => :facility, :conditions => [all_conditions, arguments], :order => '(closes_mins - opens_mins) DESC', :page => params[:page])
  end

  def outside_uk
    # very rough bounding box for UK including NI
    @status_manager = StatusManager.new
    @facilities = Facility.paginate(:all, :conditions => "lat < 49.6 OR lat > 60.93 OR lng < -8.28 OR lng > 2.15", :order => 'updated_at DESC', :page => params[:page])
  end



#  def between_openings
#    @min_length = params[:min] || 5
#    @max_length = params[:max] || 24
#    @openings = Opening.find(:all, :conditions=>"IF(closes_mins=0,1440,closes_mins)-opens_mins < #{@min_length} or IF(closes_mins=0,1440,closes_mins)-opens_mins < #{@max_length}", :order => "IF(closes_mins=0,1440,closes_mins)-opens_mins")
#  end

#  
#  def group_memberships
#    @groups = Group.find_by_sql("SELECT count(service_id) AS num_members, groups.slug, groups.name FROM groups LEFT JOIN group_memberships ON groups.id = group_id GROUP BY groups.id ORDER BY num_members")

#  end


  private
  
  def set_limit
    @limit = params[:limit].to_i
    @limit = DEFAULT_LIMIT if @limit > MAX_LIMIT || @limit == 0
  end

end
