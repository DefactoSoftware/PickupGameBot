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

ActiveRecord::Schema.define(version: 20160422153232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "attendances", force: :cascade do |t|
    t.integer "game_id"
    t.integer "player_id"
  end

  add_index "attendances", ["game_id", "player_id"], name: "index_attendances_on_game_id_and_player_id", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "chat_id"
    t.datetime "start_time"
    t.string   "game"
    t.integer  "required_players", default: 0
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.uuid     "uuid",             default: "uuid_generate_v4()"
    t.datetime "archived_at"
  end

  create_table "players", force: :cascade do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.string  "username"
    t.integer "telegram_user_id"
  end

  add_foreign_key "attendances", "games"
  add_foreign_key "attendances", "players"
end
