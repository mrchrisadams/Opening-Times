class CreateFacilityRevision < ActiveRecord::Migration
  def self.up
    create_table(:facility_revisions) do |t|
      t.integer :facility_id
      t.text    :xml
      t.integer :length
      t.string  :slug, :limit=>100
      t.string  :comment, :limit=>100
      t.integer :revision, :default => 0
      t.integer :user_id
      t.string  :ip

      t.datetime :created_at
    end
    add_index :facility_revisions, :facility_id
    add_index :facility_revisions, :user_id
    add_index :facility_revisions, :ip
  end

  def self.down
    remove_index :facility_revisions, :facility_id
    remove_index :facility_revisions, :user_id
    remove_index :facility_revisions, :ip
    drop_table :facility_revisions
  end
end
