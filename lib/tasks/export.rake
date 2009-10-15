require 'ftools'
require "progressbar"

namespace :export do

  task(:xml => [:environment]) do
    facilities = Facility.all

    if facilities.empty?
      puts "No facilties" and return
    end
    
    Dir.glob("export/*").each do |file|
      File.delete(file)
    end

    progress = ProgressBar.new("Exporting", facilities.size)
    facilities.each do |facility|
      File.open("export/#{facility.slug}.xml", "w") do |file|
        progress.inc
        file << facility.to_xml
      end
    end
    progress.finish
  end

end
