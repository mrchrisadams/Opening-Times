class CreateHolidaySets < ActiveRecord::Migration
  def self.up
    create_table :holiday_sets do |t|
      t.string :name, :limit=>50

      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_sets
  end
end
