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

ActiveRecord::Schema[7.2].define(version: 2025_01_05_165721) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_experts", id: false, force: :cascade do |t|
    t.integer "expert_id", null: false
    t.integer "category_id", null: false
  end

  create_table "experts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "academic_title"
    t.decimal "salary"
    t.text "travel_willingness"
    t.string "categories"
    t.string "profile_image"
    t.text "biography"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_id"
    t.string "password_digest"
    t.date "start_datum"
    t.date "end_datum"
  end

  create_table "one_time_links", force: :cascade do |t|
    t.string "token"
    t.boolean "used"
    t.datetime "expires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_experts", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "expert_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expert_id"], name: "index_project_experts_on_expert_id"
    t.index ["project_id"], name: "index_project_experts_on_project_id"
  end

  create_table "project_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "project_title"
    t.string "thematic_focus"
    t.date "start_date"
    t.date "end_date"
    t.string "client"
    t.string "location"
    t.string "invitation_status"
    t.string "participation_certificate_status"
    t.integer "project_type_id"
    t.boolean "archived", default: false
    t.integer "project_type"
  end

  create_table "table_project_types_with_projects", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id", null: false
    t.integer "project_type_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.boolean "initialized", default: false
    t.integer "expert_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expert_id"], name: "index_users_on_expert_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "project_experts", "experts"
  add_foreign_key "project_experts", "projects"
  add_foreign_key "projects", "project_types"
  add_foreign_key "projects", "project_types"
  add_foreign_key "users", "experts"
end

