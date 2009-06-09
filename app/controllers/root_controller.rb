class RootController < ApplicationController

  def sitemap
    @facilities = Facility.all
  end

end
