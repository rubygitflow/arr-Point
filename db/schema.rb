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

ActiveRecord::Schema.define(version: 2020_11_17_224933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # These are custom enum types that must be created before they can be used in the schema definition
  create_enum "role_type", ["Driver", "Passenger"]
  create_enum "status_type", ["Scheduled", "Execution", "Completed", "Aborted", "Rejected"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "license_plate", null: false
    t.string "model", null: false
    t.integer "year_manufacture", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "workhorse", default: false
    t.index ["user_id"], name: "index_cars_on_user_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "driver_id", null: false
    t.string "license_id"
    t.string "region", null: false
    t.integer "start_driving", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_drivers_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ride_id", null: false
    t.string "payment_confirmation"
    t.decimal "rate"
    t.decimal "tariff"
    t.decimal "price"
    t.datetime "paid_up"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_confirmation"], name: "index_payments_on_payment_confirmation", unique: true
    t.index ["ride_id"], name: "index_payments_on_ride_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "rides", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.decimal "cost"
    t.string "arrival"
    t.string "departure"
    t.string "when"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.enum "status", default: "Scheduled", as: "status_type"
    t.index ["car_id"], name: "index_rides_on_car_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "phone", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.enum "role", default: "Driver", as: "role_type"
    t.string "authy_id"
    t.datetime "last_sign_in_with_authy"
    t.boolean "authy_enabled", default: false
    t.boolean "authy_hook_enabled", default: true
    t.boolean "lock", default: false
    t.index ["authy_id"], name: "index_users_on_authy_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cars", "users"
  add_foreign_key "drivers", "users"
  add_foreign_key "payments", "rides"
  add_foreign_key "payments", "users"
  add_foreign_key "rides", "cars"
end
