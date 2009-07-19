class User < ActiveRecord::Base
  acts_as_authentic

  USER_ACTION_LIMIT = 5

  def action_count
    @action_count ||= FacilityRevision.count(:conditions => ["created_by = ? AND created_at > ?", self.id, Time.now-1.day])
  end

  def within_action_limit?
    USER_ACTION_LIMIT > action_count
  end




end
