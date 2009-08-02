class CreateHolidayEvents < ActiveRecord::Migration
  def self.up
    create_table :holiday_events do |t|
      t.integer :holiday_set_id
      t.date    :date
      t.boolean :bank_holiday
      t.string  :comment, :limit=>100

      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_events
  end
end

