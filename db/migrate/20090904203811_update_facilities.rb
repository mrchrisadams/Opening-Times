class UpdateFacilities < ActiveRecord::Migration
  def self.up
    change_column(:facilities, :slug, :string, :limit => 200)
    change_column(:facilities, :url, :string, :limit => 2083)
    remove_column(:facilities, :email)
  end

  def self.down
    change_column(:facilities, :slug, :string, :limit => 100)
    change_column(:facilities, :url, :string, :limit => 255)
    add_column(:facilities, :email, :string)
  end
end
