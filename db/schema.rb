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

ActiveRecord::Schema.define(version: 2018_06_01_040803) do

  create_table "avatars", force: :cascade do |t|
    t.string "url"
    t.string "avatarable_type"
    t.integer "avatarable_id"
    t.index ["avatarable_type", "avatarable_id"], name: "index_avatars_on_avatarable_type_and_avatarable_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_comments_on_topic_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.integer "node_id"
    t.string "name"
    t.string "slug"
    t.string "tagline"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["node_id"], name: "index_nodes_on_node_id"
    t.index ["user_id"], name: "index_nodes_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "priority"
    t.string "name"
    t.string "alias"
    t.string "verb"
    t.string "path"
    t.string "controller"
    t.string "action"
    t.string "params_permit"
    t.string "params_range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posttexts", force: :cascade do |t|
    t.text "body"
    t.string "textable_type"
    t.integer "textable_id"
    t.index ["textable_type", "textable_id"], name: "index_posttexts_on_textable_type_and_textable_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "node_id"
    t.index ["node_id"], name: "index_topics_on_node_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
