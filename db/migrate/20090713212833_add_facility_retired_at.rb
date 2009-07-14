class AddFacilityRetiredAt < ActiveRecord::Migration
  def self.up
    add_column :facilities, :retired_at, :datetime, :default => nil
  end

  def self.down
    remove_column :facilities, :retired_at
  end
end
