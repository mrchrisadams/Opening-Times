class CreateFacilities < ActiveRecord::Migration
  def self.up
    create_table :facilities do |t|
      t.integer :holiday_set_id
      t.integer :user_id

      t.string  :slug, :limit=>100
      t.string  :name, :limit=>100
      t.string  :location, :limit=>100
      t.string  :address
      t.string  :postcode, :limit=>8
      t.string  :phone, :limit=>15
      t.string  :email
      t.string  :url
      t.text    :description
      t.string  :summary_normal_openings

      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10

      t.integer :revision, :default => 0
      t.string  :comment, :limit=>100
      t.string  :updated_from_ip

      t.timestamps
    end
    add_index :facilities, :slug, :unique => true
    add_index :facilities, [:lat, :lng]
  end

  def self.down
    remove_index :facilities, :slug
    remove_index :facilities, [:lat, :lng]
    drop_table :facilities
  end
end
