# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090530230714) do

  create_table "facilities", :force => true do |t|
    t.string   "slug",        :limit => 200
    t.string   "name",        :limit => 100
    t.string   "location",    :limit => 100
    t.string   "address"
    t.string   "postcode",    :limit => 8
    t.string   "phone",       :limit => 15
    t.string   "email"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facilities", ["slug"], :name => "index_facilities_on_slug", :unique => true

  create_table "openings", :force => true do |t|
    t.integer "facility_id"
    t.integer "opens_mins"
    t.integer "closes_mins"
    t.date    "starts_on"
    t.date    "ends_on"
    t.integer "sequence"
    t.string  "comment",     :limit => 100
    t.string  "type",        :limit => 20
  end

  add_index "openings", ["facility_id"], :name => "index_openings_on_facility_id"
  add_index "openings", ["opens_mins", "closes_mins"], :name => "index_openings_on_opens_mins_and_closes_mins"
  add_index "openings", ["type"], :name => "index_openings_on_type"

end
