class UpdateFacilitiesForRevisions < ActiveRecord::Migration
  def self.up
    add_column :facilities, :comment, :string
    rename_column :facilities, :version, :revision
    change_column_default(:facilities, :revision, 0)
  end

  def self.down
    remove_column :facilities, :comment
    rename_column :facilities, :revision, :version
    change_column_default(:facilities, :revision, nil)
  end
end
