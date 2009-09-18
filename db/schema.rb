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

ActiveRecord::Schema.define(:version => 20090917075255) do

  create_table "facilities", :force => true do |t|
    t.integer  "holiday_set_id"
    t.integer  "user_id"
    t.string   "slug",                    :limit => 200
    t.string   "name",                    :limit => 100
    t.string   "location",                :limit => 100
    t.string   "address"
    t.string   "postcode",                :limit => 8
    t.string   "phone",                   :limit => 15
    t.string   "url",                     :limit => 2083
    t.text     "description"
    t.string   "summary_normal_openings"
    t.decimal  "lat",                                     :precision => 15, :scale => 10
    t.decimal  "lng",                                     :precision => 15, :scale => 10
    t.integer  "revision",                                                                :default => 1
    t.string   "comment",                 :limit => 100
    t.string   "updated_from_ip"
    t.datetime "retired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facilities", ["lat", "lng"], :name => "index_facilities_on_lat_and_lng"
  add_index "facilities", ["slug"], :name => "index_facilities_on_slug", :unique => true

  create_table "facility_revisions", :force => true do |t|
    t.integer  "facility_id"
    t.text     "xml"
    t.integer  "length"
    t.string   "slug",        :limit => 100
    t.string   "comment",     :limit => 100
    t.integer  "revision",                   :default => 0
    t.integer  "user_id"
    t.string   "ip"
    t.datetime "created_at"
  end

  add_index "facility_revisions", ["facility_id"], :name => "index_facility_revisions_on_facility_id"
  add_index "facility_revisions", ["ip"], :name => "index_facility_revisions_on_ip"
  add_index "facility_revisions", ["user_id"], :name => "index_facility_revisions_on_user_id"

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "facility_id"
    t.datetime "created_at"
  end

  add_index "group_memberships", ["group_id", "facility_id"], :name => "index_group_memberships_on_group_id_and_facility_id"

  create_table "groups", :force => true do |t|
    t.string   "name",        :limit => 100
    t.string   "slug",        :limit => 100
    t.integer  "style"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.decimal  "lat",                         :precision => 15, :scale => 10
    t.decimal  "lng",                         :precision => 15, :scale => 10
    t.string   "url",         :limit => 2083
  end

  add_index "groups", ["slug"], :name => "index_groups_on_slug", :unique => true
  add_index "groups", ["type"], :name => "index_groups_on_type"

  create_table "holiday_events", :force => true do |t|
    t.integer  "holiday_set_id"
    t.date     "date"
    t.boolean  "bank_holiday"
    t.string   "comment",        :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holiday_sets", :force => true do |t|
    t.string   "name",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "openings", :force => true do |t|
    t.integer  "facility_id"
    t.integer  "opens_mins"
    t.integer  "closes_mins"
    t.date     "starts_on"
    t.date     "ends_on"
    t.integer  "sequence"
    t.boolean  "closed"
    t.string   "comment",     :limit => 100
    t.string   "type",        :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "openings", ["facility_id"], :name => "index_openings_on_facility_id"
  add_index "openings", ["opens_mins", "closes_mins"], :name => "index_openings_on_opens_mins_and_closes_mins"
  add_index "openings", ["type"], :name => "index_openings_on_type"
  add_index "openings", ["updated_at"], :name => "index_openings_on_updated_at"

  create_table "slug_traps", :force => true do |t|
    t.string   "slug",          :limit => 100
    t.string   "redirect_slug", :limit => 100
    t.string   "type",          :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slug_traps", ["type", "slug"], :name => "index_slug_traps_on_type_and_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.string   "perishable_token",                  :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
