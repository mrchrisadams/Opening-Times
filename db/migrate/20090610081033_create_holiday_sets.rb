class CreateHolidaySets < ActiveRecord::Migration
  def self.up
    create_table :holiday_sets do |t|
      t.string :name, :limit=>100

      t.timestamps
    end

    add_column(:facilities, :holiday_set_id, :integer)
  end

  def self.down
    drop_table :holiday_sets

    remove_column(:facilities, :holiday_set_id)
  end
end
