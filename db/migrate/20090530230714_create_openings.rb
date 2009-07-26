class CreateOpenings < ActiveRecord::Migration
  def self.up
    create_table :openings do |t|
      t.integer :facility_id
      t.integer :opens_mins
      t.integer :closes_mins
      t.date    :starts_on
      t.date    :ends_on
      t.integer :sequence
      t.boolean :closed
      t.string  :comment, :limit=>100
      t.string  :type, :limit=>20
    end
    add_index :openings, :facility_id
    add_index :openings, :type
    add_index :openings, [:opens_mins, :closes_mins]
  end

  def self.down
    remove_index :openings, :facility_id
    remove_index :openings, :type
    remove_index :openings, [:opens_mins, :closes_mins]
    drop_table :openings
  end
end

