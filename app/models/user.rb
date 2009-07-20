class User < ActiveRecord::Base
  acts_as_authentic

  has_many :facilities
  has_many :facility_revisions

  USER_ACTION_LIMIT = 30

  def action_count
    @action_count ||= FacilityRevision.count(:conditions => ["user_id = ? AND created_at > ?", self.id, Time.now-1.day])
  end

  def within_action_limit?
    USER_ACTION_LIMIT > action_count
  end




end
