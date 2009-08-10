class FacilityObserver < ActiveRecord::Observer

  def after_save(facility)
    FacilityRevision.create!(:facility=>facility)
  end

end
