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

ActiveRecord::Schema.define(version: 20150812222448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.integer  "clinic_id"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "doctor_id"
    t.integer  "patient_id"
    t.datetime "confirmed_at"
    t.boolean  "cancelled",    default: false
  end

  add_index "appointments", ["clinic_id"], name: "index_appointments_on_clinic_id", using: :btree

  create_table "availabilities", force: :cascade do |t|
    t.integer  "doctor_id"
    t.integer  "clinic_id"
    t.integer  "day"
    t.string   "begin_time"
    t.string   "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clinics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pesel"
    t.string   "address"
    t.string   "pwz"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "appointments", "clinics"
  add_foreign_key "appointments", "users", column: "doctor_id", on_delete: :cascade
  add_foreign_key "appointments", "users", column: "patient_id", on_delete: :cascade
  add_foreign_key "availabilities", "clinics", on_delete: :cascade
  add_foreign_key "availabilities", "users", column: "doctor_id", on_delete: :cascade
end
