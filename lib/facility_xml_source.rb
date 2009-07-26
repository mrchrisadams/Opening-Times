require 'hpricot'
require "progressbar"

class FacilityXmlSource

  DATA_ROOT = File.dirname(__FILE__) + "/../../opening-times-data/"

  def initialize(facility_name)
    @facility_name = facility_name || "**"
    @files = Dir[xml_path + "*.xml"]
    @attempt_count = @files.size
    @success_count = 0
  end

  def xml_path
    "#{DATA_ROOT}/#{@facility_name}/xml/"
  end

  def import
    puts "#{@files.size} file(s)"
    progress = ProgressBar.new("Importing", @files.size)

    @files.each do |file|
      progress.inc
      f = Facility.new
      f.from_xml(File.open(file).read)
      f.user_id = 0
      f.updated_from_ip = "0.0.0.0"
      f.save!
    end
    progress.finish
  end

end

