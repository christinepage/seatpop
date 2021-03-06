# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150421084904) do

  create_table "parties", force: :cascade do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.integer  "size"
    t.string   "phone"
    t.string   "notes"
    t.datetime "seated_time"
    t.datetime "exit_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "party_status_id"
    t.integer  "token"
  end

  add_index "parties", ["party_status_id"], name: "index_parties_on_party_status_id"
  add_index "parties", ["restaurant_id"], name: "index_parties_on_restaurant_id"

  create_table "party_statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "est_wait_time"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "picture"
  end

  add_index "restaurants", ["user_id"], name: "index_restaurants_on_user_id"

  create_table "restaurants_users", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "api_authtoken"
    t.datetime "authtoken_expiry"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
