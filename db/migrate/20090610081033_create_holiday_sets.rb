class CreateHolidaySets < ActiveRecord::Migration
  def self.up
    create_table :holiday_sets do |t|
      t.string :name, :limit=>50

      t.timestamps
    end
    HolidaySet.create!(:name => "England & Wales")
    HolidaySet.create!(:name => "Scotland")
    HolidaySet.create!(:name => "Northern Ireland")
  end

  def self.down
    drop_table :holiday_sets
  end
end

