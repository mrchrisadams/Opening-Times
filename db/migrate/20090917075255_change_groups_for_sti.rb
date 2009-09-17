class ChangeGroupsForSti < ActiveRecord::Migration
  def self.up
    add_column :groups, :type, :string #type column for single table inheritance
    add_column :groups, :lat, :decimal, :precision => 15, :scale => 10
    add_column :groups, :lng, :decimal, :precision => 15, :scale => 10
    add_column :groups, :url, :string, :limit => 2083

    add_index :groups, :type
  end

  def self.down
    remove_column :groups, :type
    remove_column :groups, :lat
    remove_column :groups, :lng
    remove_column :groups, :url
  end
end
