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

ActiveRecord::Schema[8.1].define(version: 2026_05_26_132838) do
  create_table "veterinary_clinics", force: :cascade do |t|
    t.string "accepted_species", default: "", null: false
    t.boolean "active", default: true, null: false
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_emergency", default: false, null: false
    t.boolean "is_open_now", default: false, null: false
    t.datetime "last_verified_at"
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "name", null: false
    t.string "open_hours", null: false
    t.string "phone", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["active"], name: "index_veterinary_clinics_on_active"
    t.index ["is_emergency"], name: "index_veterinary_clinics_on_is_emergency"
    t.index ["is_open_now"], name: "index_veterinary_clinics_on_is_open_now"
    t.index ["latitude", "longitude"], name: "index_veterinary_clinics_on_latitude_and_longitude"
  end
end
