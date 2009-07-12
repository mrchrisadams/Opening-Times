#require 'diff_to_html'
#require 'html_diff'
require 'diff-display'

class CompareController < ApplicationController

  COMPARE_TMP_DIR = "/tmp/opening-times/facility-revisions"

  def index

    v1_id = params[:a].to_i
    v2_id = params[:b].to_i

    # v1 = older version, v2 = newer version
    v1_id, v2_id = v2_id, v1_id if v1_id > v2_id

    @v1 = FacilityRevision.find(v1_id)
    @v2 = FacilityRevision.find(v2_id)

#    @html_diff = HTMLDiff.diff(@v1.value,@v2.value)
    `mkdir -p #{COMPARE_TMP_DIR}`

    f1 = "#{COMPARE_TMP_DIR}/#{@v1.id}.xml"
    File.open(f1,"w") do |f|
      f << @v1.xml
    end

    f2 = "#{COMPARE_TMP_DIR}/#{@v2.id}.xml"
    File.open(f2,"w") do |f|
      f << @v2.xml
    end

#    @html_diff = %x[java -jar /home/julian/Desktop/daisydiff-1.0/daisydiff.jar #{RAILS_ROOT}/tmp/histories/#{@v1.id}.xml #{RAILS_ROOT}/tmp/histories/#{@v2.id}.xml  --type=tag --file=#{RAILS_ROOT}/tmp/histories/#{@v1.id}-#{@v2.id}.xml]

#    File.open("tmp/histories/#{@v1.id}-#{@v2.id}.xml") do |f|
#      @html_diff = f.read
#    end

#    #delete the first 14 lines
#    @html_diff.sub!(/^([^\n]*\n){14}/m,'').gsub("/t","&nbsp;&nbsp;")

    @diff = `git diff #{f1} #{f2}`
#    converter = GitDiffToHtml.new #there's also GitDiffToHtml
#    @html_diff =  converter.composite_to_html(diff)
#     @html_diff = HTMLDiff.diff(@v1.xml, @v2.xml)
  end

end
