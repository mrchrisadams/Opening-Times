class UpdateFacilitiesForRevisions < ActiveRecord::Migration
  def self.up
    add_column :facilities, :comment, :string
    rename_column :facilities, :version, :revision
    change_column_default(:facilities, :revision, 0)
  end

  def self.down
  end
end
