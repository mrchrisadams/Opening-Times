class FacilityObserver < ActiveRecord::Observer


  def after_save(facility)
    FacilityRevision.create!(:facility=>facility)

#    facility.reload # Updates to openings were being lost
#    revision = FacilityRevision.new
#  # I would like to have this in create, but AR can't access facility until is has been fully saved and we are still within the transaction
#    revision.update_from_facility(facility)
#    revision.save!
  end

end
