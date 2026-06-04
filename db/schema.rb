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

ActiveRecord::Schema[8.1].define(version: 2026_06_04_034151) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "construction_records", force: :cascade do |t|
    t.integer "construction_cost"
    t.text "cost_memo"
    t.datetime "created_at", null: false
    t.text "intent"
    t.integer "labor_cost"
    t.text "next_steps"
    t.text "observations"
    t.text "photo_captions"
    t.text "photo_types"
    t.bigint "project_id"
    t.string "site"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "work_items"
    t.date "worked_on", null: false
    t.index ["project_id"], name: "index_construction_records_on_project_id"
    t.index ["user_id"], name: "index_construction_records_on_user_id"
  end

  create_table "estimates", force: :cascade do |t|
    t.boolean "apply_tax", default: true, null: false
    t.string "client_name"
    t.datetime "created_at", null: false
    t.date "doc_date", null: false
    t.string "doc_number"
    t.jsonb "items", default: []
    t.text "note"
    t.bigint "project_id", null: false
    t.string "share_token"
    t.datetime "share_token_expires_at"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_estimates_on_project_id"
    t.index ["share_token"], name: "index_estimates_on_share_token", unique: true
    t.index ["user_id"], name: "index_estimates_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "amount"
    t.string "client_name"
    t.datetime "created_at", null: false
    t.date "due_date"
    t.date "invoiced_on"
    t.text "note"
    t.bigint "project_id", null: false
    t.string "share_token"
    t.datetime "share_token_expires_at"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_invoices_on_project_id"
    t.index ["share_token"], name: "index_invoices_on_share_token", unique: true
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.text "caption"
    t.datetime "created_at", null: false
    t.integer "photo_type", default: 1, null: false
    t.integer "position", default: 0, null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id"], name: "index_photos_on_blob_id"
    t.index ["photo_type"], name: "index_photos_on_photo_type"
    t.index ["record_type", "record_id"], name: "index_photos_on_record"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "sites", default: [], array: true
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "receipts", force: :cascade do |t|
    t.integer "amount"
    t.string "client_name"
    t.datetime "created_at", null: false
    t.text "note"
    t.string "payment_method"
    t.bigint "project_id", null: false
    t.date "received_on"
    t.string "share_token"
    t.datetime "share_token_expires_at"
    t.string "tadashi"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["project_id"], name: "index_receipts_on_project_id"
    t.index ["share_token"], name: "index_receipts_on_share_token", unique: true
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "account_holder"
    t.string "account_number"
    t.string "account_type"
    t.string "bank_name"
    t.string "branch_name"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "ws_logs", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.date "held_on"
    t.text "improvements"
    t.string "participant_notes"
    t.integer "participants_count"
    t.bigint "project_id", null: false
    t.text "reactions"
    t.text "reflection"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "weather"
    t.index ["project_id"], name: "index_ws_logs_on_project_id"
    t.index ["user_id"], name: "index_ws_logs_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "construction_records", "projects"
  add_foreign_key "construction_records", "users"
  add_foreign_key "estimates", "projects"
  add_foreign_key "estimates", "users"
  add_foreign_key "invoices", "projects"
  add_foreign_key "invoices", "users"
  add_foreign_key "photos", "active_storage_blobs", column: "blob_id"
  add_foreign_key "receipts", "projects"
  add_foreign_key "receipts", "users"
  add_foreign_key "ws_logs", "projects"
  add_foreign_key "ws_logs", "users"
end
