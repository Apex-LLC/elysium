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

ActiveRecord::Schema.define(version: 20190718194825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "billing_cycle_start_day"
    t.integer "days_until_invoice_due"
    t.string "stripe_account_id"
  end

  create_table "admin_costs", force: :cascade do |t|
    t.string "label"
    t.string "description"
    t.float "percent"
    t.float "flat_fee"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_admin_costs_on_account_id"
  end

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
    t.bigint "account_id"
    t.boolean "is_peak_demand_meter", default: false
    t.index ["account_id"], name: "index_billable_meters_on_account_id"
    t.index ["meter_id"], name: "index_billable_meters_on_meter_id"
    t.index ["rate_id"], name: "index_billable_meters_on_rate_id"
    t.index ["space_id"], name: "index_billable_meters_on_space_id"
    t.index ["tenant_id"], name: "index_billable_meters_on_tenant_id"
  end

  create_table "billable_meters_invoices", id: false, force: :cascade do |t|
    t.integer "invoice_id"
    t.integer "billable_meter_id"
  end

  create_table "invoice_meters", force: :cascade do |t|
    t.string "reference"
    t.float "usage"
    t.float "rate"
    t.decimal "amount_due", precision: 8, scale: 2
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_meters_on_invoice_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tenant_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "send_date"
    t.decimal "amount", precision: 8, scale: 2
    t.decimal "fees", precision: 8, scale: 2
    t.datetime "due_date"
    t.integer "status"
    t.text "graphable_data"
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
    t.bigint "invoice_id"
    t.string "email"
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
    t.index ["tenant_id"], name: "index_payments_on_tenant_id"
  end

  create_table "rates", force: :cascade do |t|
    t.string "symbol"
    t.float "rate"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_rates_on_account_id"
  end

  create_table "records", id: :serial, force: :cascade do |t|
    t.datetime "datetime"
    t.float "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meter_id"
    t.index ["datetime", "meter_id"], name: "index_records_on_datetime_and_meter_id", unique: true
    t.index ["datetime"], name: "index_records_on_datetime"
    t.index ["meter_id"], name: "index_records_on_meter_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_sites_on_account_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_spaces_on_site_id"
  end

  create_table "tenant_fees", force: :cascade do |t|
    t.bigint "tenant_id"
    t.decimal "amount", precision: 8, scale: 2
    t.boolean "recurring"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.string "description"
    t.index ["account_id"], name: "index_tenant_fees_on_account_id"
    t.index ["tenant_id"], name: "index_tenant_fees_on_tenant_id"
  end

  create_table "tenant_users", id: false, force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_tenant_users_on_tenant_id"
    t.index ["user_id"], name: "index_tenant_users_on_user_id"
  end

  create_table "tenants", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone"
    t.string "email"
    t.bigint "space_id"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.bigint "account_id"
    t.string "stripe_token"
    t.boolean "payments_verified", default: false
    t.index ["account_id"], name: "index_tenants_on_account_id"
    t.index ["space_id"], name: "index_tenants_on_space_id"
  end

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "tenant_id"
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
    t.string "name"
    t.string "phone"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "admin_costs", "accounts"
  add_foreign_key "billable_meters", "accounts"
  add_foreign_key "billable_meters", "meters"
  add_foreign_key "billable_meters", "rates"
  add_foreign_key "billable_meters", "spaces"
  add_foreign_key "billable_meters", "tenants"
  add_foreign_key "invoice_meters", "invoices"
  add_foreign_key "invoices", "tenants"
  add_foreign_key "meters", "sites"
  add_foreign_key "payments", "invoices"
  add_foreign_key "payments", "tenants"
  add_foreign_key "rates", "accounts"
  add_foreign_key "records", "meters"
  add_foreign_key "sites", "accounts"
  add_foreign_key "spaces", "sites"
  add_foreign_key "tenant_fees", "accounts"
  add_foreign_key "tenant_fees", "tenants"
  add_foreign_key "tenant_users", "tenants"
  add_foreign_key "tenant_users", "users"
  add_foreign_key "tenants", "accounts"
  add_foreign_key "tenants", "spaces"
  add_foreign_key "users", "accounts"
end
