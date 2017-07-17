# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170717203648) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "author"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["user_id"], name: "index_blogs_on_user_id", using: :btree
  end

  create_table "commissions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "traveler_names"
    t.string   "traveler_phone"
    t.string   "traveler_email"
    t.date     "depart"
    t.date     "return"
    t.string   "itinerary"
    t.string   "ticket"
    t.string   "supplier"
    t.string   "airline"
    t.string   "hotel"
    t.string   "car_rental"
    t.string   "form"
    t.integer  "last_4"
    t.string   "comments"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.decimal  "trip_total",     precision: 8, scale: 4
    t.decimal  "estimate",       precision: 8, scale: 4
    t.string   "agent_id"
    t.string   "zip"
    t.boolean  "processed"
    t.string   "c2go"
    t.string   "key"
    t.index ["user_id"], name: "index_commissions_on_user_id", using: :btree
  end

  create_table "cruises", force: :cascade do |t|
    t.string   "title"
    t.date     "departure"
    t.date     "return"
    t.integer  "vacancy"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_cruises_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
    t.index ["topic_id"], name: "index_messages_on_topic_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "allowed",            default: false, null: false
    t.string   "name"
    t.string   "location"
    t.date     "traveled_on"
    t.string   "description"
    t.index ["user_id"], name: "index_photos_on_user_id", using: :btree
  end

  create_table "specials", force: :cascade do |t|
    t.string   "title"
    t.date     "depart"
    t.date     "return"
    t.integer  "vacancy"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.decimal  "price",              precision: 8, scale: 2
    t.boolean  "featured"
    t.string   "location"
    t.index ["user_id"], name: "index_specials_on_user_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "first"
    t.string   "last"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "request_name"
    t.index ["user_id"], name: "index_topics_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "username"
    t.string   "first"
    t.string   "last"
    t.string   "password_digest"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "phone_number"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "about"
    t.boolean  "permod"
    t.string   "agent_id"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "c2go"
    t.string   "apt"
    t.integer  "upline_id"
  end

  add_foreign_key "blogs", "users"
  add_foreign_key "commissions", "users"
  add_foreign_key "cruises", "users"
  add_foreign_key "messages", "topics"
  add_foreign_key "messages", "users"
  add_foreign_key "photos", "users"
  add_foreign_key "specials", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "topics", "users"
end
