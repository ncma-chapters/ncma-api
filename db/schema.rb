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

ActiveRecord::Schema.define(version: 2020_03_21_052402) do

  create_table "event_registrations", force: :cascade do |t|
    t.json "data", null: false
    t.integer "ticket_class_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_class_id"], name: "index_event_registrations_on_ticket_class_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "published_at"
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.datetime "canceled_at"
    t.integer "venue_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["published_at"], name: "index_events_on_published_at"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "ticket_classes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "minimum_quantity"
    t.integer "maximum_quantity"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "sorting"
    t.integer "capacity"
    t.datetime "sales_start"
    t.datetime "sales_end"
    t.string "order_confirmation_message"
    t.integer "event_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_ticket_classes_on_deleted_at"
    t.index ["event_id"], name: "index_ticket_classes_on_event_id"
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

  add_foreign_key "event_registrations", "ticket_classes"
  add_foreign_key "events", "venues"
  add_foreign_key "ticket_classes", "events"
end
