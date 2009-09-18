class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.integer :group_id
      t.integer :facility_id

      t.datetime :created_at
    end
    add_index :group_memberships, [:group_id, :facility_id]
  end

  def self.down
    remove_index :group_memberships, [:group_id, :facility_id]
    drop_table :group_memberships
  end
end
