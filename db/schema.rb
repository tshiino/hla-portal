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

ActiveRecord::Schema.define(version: 20150226081130) do

  create_table "allele_master_as", force: :cascade do |t|
    t.string   "name",                 limit: 16
    t.integer  "priority",             limit: 4
    t.integer  "serotype_master_a_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "allele_master_as", ["serotype_master_a_id"], name: "index_allele_master_as_on_serotype_master_a_id", using: :btree

  create_table "allele_master_bs", force: :cascade do |t|
    t.string   "name",                 limit: 16
    t.integer  "priority",             limit: 4
    t.integer  "serotype_master_b_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "allele_master_bs", ["serotype_master_b_id"], name: "index_allele_master_bs_on_serotype_master_b_id", using: :btree

  create_table "allele_master_cs", force: :cascade do |t|
    t.string   "name",                 limit: 16
    t.integer  "priority",             limit: 4
    t.integer  "serotype_master_c_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "allele_master_cs", ["serotype_master_c_id"], name: "index_allele_master_cs_on_serotype_master_c_id", using: :btree

  create_table "country_codes", force: :cascade do |t|
    t.string   "code",       limit: 4
    t.string   "country",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "hlas", force: :cascade do |t|
    t.string   "type",        limit: 255,                 null: false
    t.integer  "patient_id",  limit: 4,                   null: false
    t.date     "date_exam"
    t.string   "serotype",    limit: 4
    t.string   "allele",      limit: 255
    t.boolean  "homo",        limit: 1,   default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "operator_id", limit: 4
    t.string   "dserotype",   limit: 4
    t.string   "dallele",     limit: 16
  end

  add_index "hlas", ["patient_id"], name: "index_hlas_on_patient_id", using: :btree
  add_index "hlas", ["serotype", "allele"], name: "index_hlas_on_serotype_and_allele", using: :btree
  add_index "hlas", ["type"], name: "index_hlas_on_type", using: :btree

  create_table "institutes_masters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microposts", force: :cascade do |t|
    t.string   "content",    limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "patients", force: :cascade do |t|
    t.string   "niid_id",          limit: 16
    t.string   "lab_id",           limit: 16
    t.string   "affiliation",      limit: 16
    t.string   "hosp_id",          limit: 16
    t.string   "gender",           limit: 16
    t.integer  "nationarity",      limit: 4
    t.date     "date_of_birth"
    t.date     "date_diagnosed"
    t.string   "edu_background",   limit: 32
    t.string   "occupation",       limit: 128
    t.string   "marital_status",   limit: 16
    t.string   "risk",             limit: 16
    t.integer  "operator_id",      limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.date     "date_of_art_init"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id", limit: 4
    t.integer  "followed_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "serotype_master_as", force: :cascade do |t|
    t.string   "name",       limit: 4
    t.integer  "priority",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "serotype_master_bs", force: :cascade do |t|
    t.string   "name",       limit: 4
    t.integer  "priority",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "serotype_master_cs", force: :cascade do |t|
    t.string   "name",       limit: 4
    t.integer  "priority",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: 255
    t.string   "remember_token",  limit: 255
    t.boolean  "admin",           limit: 1,   default: false
    t.integer  "affiliation",     limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "allele_master_as", "serotype_master_as"
  add_foreign_key "allele_master_bs", "serotype_master_bs"
  add_foreign_key "allele_master_cs", "serotype_master_cs"
  add_foreign_key "hlas", "patients"
end
