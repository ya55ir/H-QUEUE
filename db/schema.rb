# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_15_065242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "queue_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "notified_at"
    t.integer "party_size"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "venue_id", null: false
    t.index ["user_id"], name: "index_queue_entries_on_user_id"
    t.index ["venue_id"], name: "index_queue_entries_on_venue_id"
  end

  create_table "table_types", force: :cascade do |t|
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.bigint "venue_id", null: false
    t.index ["venue_id"], name: "index_table_types_on_venue_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "is_manager", default: false, null: false
    t.boolean "marketing_opt_in", default: false
    t.string "phone_number"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.boolean "terms_opt_in", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "address"
    t.integer "avg_wait_minutes"
    t.datetime "created_at", null: false
    t.text "description"
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.text "opening_hours"
    t.string "photo_url"
    t.datetime "updated_at", null: false
    t.string "venue_type"
  end

  add_foreign_key "queue_entries", "users"
  add_foreign_key "queue_entries", "venues"
  add_foreign_key "table_types", "venues"
end
