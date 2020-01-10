# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_09_214559) do

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "venue_id"
    t.datetime "published_at"
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["published_at"], name: "index_events_on_published_at"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.integer "age_restriction"
    t.integer "capacity"
    t.json "address"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_venues_on_deleted_at"
  end

  add_foreign_key "events", "venues"
end
