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

ActiveRecord::Schema.define(version: 2022_04_29_101806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "score_details", force: :cascade do |t|
    t.text "coords", null: false, array: true
    t.string "pickup_address", null: false
    t.string "dropoff_address", null: false
    t.datetime "pickup_time", null: false
    t.datetime "dropoff_time", null: false
    t.integer "fare", null: false
    t.bigint "score_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["score_id"], name: "index_score_details_on_score_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "score", default: 0, null: false
    t.datetime "start_time", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["start_time", "user_id"], name: "index_scores_on_start_time_and_user_id", unique: true
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

  add_foreign_key "score_details", "scores"
  add_foreign_key "scores", "users"
end
