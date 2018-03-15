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

ActiveRecord::Schema.define(version: 20180309183313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billable_meters", id: :serial, force: :cascade do |t|
    t.integer "percent_allocation"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tenant_id"
    t.bigint "space_id"
    t.bigint "meter_id"
    t.string "description"
    t.bigint "rate_id", null: false
    t.index ["meter_id"], name: "index_billable_meters_on_meter_id"
    t.index ["rate_id"], name: "index_billable_meters_on_rate_id"
    t.index ["space_id"], name: "index_billable_meters_on_space_id"
    t.index ["tenant_id"], name: "index_billable_meters_on_tenant_id"
  end

  create_table "billable_meters_invoices", id: false, force: :cascade do |t|
    t.integer "invoice_id"
    t.integer "billable_meter_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tenant_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "send_date"
    t.string "status"
    t.decimal "amount", precision: 8, scale: 2
    t.index ["tenant_id"], name: "index_invoices_on_tenant_id"
  end

  create_table "meters", id: :serial, force: :cascade do |t|
    t.string "reference"
    t.datetime "last_collection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "site_id"
    t.string "datatype"
    t.string "unit"
    t.index ["reference", "site_id"], name: "index_meters_on_reference_and_site_id", unique: true
    t.index ["site_id"], name: "index_meters_on_site_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.decimal "amount", precision: 8, scale: 2
    t.integer "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_payments_on_tenant_id"
  end

  create_table "rates", force: :cascade do |t|
    t.string "symbol"
    t.float "rate"
    t.string "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "records", id: :serial, force: :cascade do |t|
    t.datetime "datetime"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meter_id"
    t.index ["datetime", "meter_id"], name: "index_records_on_datetime_and_meter_id", unique: true
    t.index ["meter_id"], name: "index_records_on_meter_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "website"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sites_on_user_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_spaces_on_site_id"
  end

  create_table "tenants", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.string "email"
    t.bigint "user_id"
    t.bigint "space_id"
    t.index ["space_id"], name: "index_tenants_on_space_id"
    t.index ["user_id"], name: "index_tenants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "token", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "billable_meters", "meters"
  add_foreign_key "billable_meters", "rates"
  add_foreign_key "billable_meters", "spaces"
  add_foreign_key "billable_meters", "tenants"
  add_foreign_key "invoices", "tenants"
  add_foreign_key "meters", "sites"
  add_foreign_key "payments", "tenants"
  add_foreign_key "rates", "users"
  add_foreign_key "records", "meters"
  add_foreign_key "sites", "users"
  add_foreign_key "spaces", "sites"
  add_foreign_key "tenants", "spaces"
  add_foreign_key "tenants", "users"
end
