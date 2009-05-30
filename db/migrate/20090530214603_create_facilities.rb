class CreateFacilities < ActiveRecord::Migration
  def self.up
    create_table :facilities do |t|
      t.string :slug, :limit=>200
      t.string :name, :limit=>100
      t.string :location, :limit=>100
      t.string :address
      t.string :postcode, :limit=>8
      t.string :phone, :limit=>15
      t.string :email
      t.string :url
      t.text :description

      t.timestamps
    end
    add_index :facilities, :slug, :unique => true
  end

  def self.down
    remove_index :facilities, :slug
    drop_table :facilities
  end
end
