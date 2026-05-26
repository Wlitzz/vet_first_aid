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

ActiveRecord::Schema[8.1].define(version: 2026_05_26_003641) do
  create_table "first_aid_procedures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "severity"
    t.string "species"
    t.text "symptom_keywords"
    t.datetime "updated_at", null: false
  end

  create_table "instructional_videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "first_aid_procedure_id"
    t.integer "step_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["first_aid_procedure_id"], name: "index_instructional_videos_on_first_aid_procedure_id"
    t.index ["step_id"], name: "index_instructional_videos_on_step_id"
  end

  create_table "steps", force: :cascade do |t|
    t.text "checklist"
    t.datetime "created_at", null: false
    t.integer "first_aid_procedure_id", null: false
    t.text "instruction", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["first_aid_procedure_id", "position"], name: "index_steps_on_first_aid_procedure_id_and_position", unique: true
    t.index ["first_aid_procedure_id"], name: "index_steps_on_first_aid_procedure_id"
  end

  add_foreign_key "instructional_videos", "first_aid_procedures"
  add_foreign_key "instructional_videos", "steps"
  add_foreign_key "steps", "first_aid_procedures"
end
