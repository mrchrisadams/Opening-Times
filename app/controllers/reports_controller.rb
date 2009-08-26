class ReportsController < ApplicationController


  def long_locations
    @facilities = Facility.paginate(:all, :order => 'LENGTH(location) DESC', :page => params[:page])
  end

  def noon
    @openings = NormalOpening.paginate(:all, :include => :facility, :conditions => "opens_mins = 720 or closes_mins = 720", :order => 'id DESC', :page => params[:page])
  end

  def openings_count
    @limit = (params[:limit] || 100).to_i
    @limit = 100 if @limit > 1000
    @min = (params[:min] || 7).to_i
    @max = (params[:max] || 7).to_i
    @max = @min if @min > @max
    @facilities = Facility.find_by_sql("SELECT facilities.id, name, location, updated_at, count(openings.id) AS openings_count FROM facilities LEFT JOIN openings ON facilities.id = facility_id GROUP BY facilities.id HAVING openings_count < #{@min} or openings_count > #{@max} ORDER BY updated_at DESC LIMIT #{@limit}")
  end

#  def between_openings
#    @min_length = params[:min] || 5
#    @max_length = params[:max] || 24
#    @openings = Opening.find(:all, :conditions=>"IF(closes_mins=0,1440,closes_mins)-opens_mins < #{@min_length} or IF(closes_mins=0,1440,closes_mins)-opens_mins < #{@max_length}", :order => "IF(closes_mins=0,1440,closes_mins)-opens_mins")
#  end

#  def length_openings
#    @length = params[:length]    
#    @openings = Opening.find(:all,:include=>:service,:conditions=>["(IF(closes_mins=0,1440,closes_mins)-opens_mins)=?",@length],:order=>'services.name,sequence,opens_mins')
#  end

#  
#  def group_memberships
#    @groups = Group.find_by_sql("SELECT count(service_id) AS num_members, groups.slug, groups.name FROM groups LEFT JOIN group_memberships ON groups.id = group_id GROUP BY groups.id ORDER BY num_members")

#  end


end
