class CreateFacilityRevision < ActiveRecord::Migration
  def self.up
    create_table(:facility_revisions) do |t|
      t.integer :facility_id
      t.text    :xml
      t.integer :length
      t.string  :slug,      :limit=>100
      t.string  :comment,   :limit=>100
      t.integer :revision
      t.string  :created_by

      t.datetime :created_at
    end
    add_index :facility_revisions, :facility_id
  end

  def self.down
    drop_table :facility_revisions
  end
end
