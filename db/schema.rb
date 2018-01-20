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

ActiveRecord::Schema.define(version: 20180120105927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "description"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "commune_admins", force: :cascade do |t|
    t.integer "user_id"
    t.integer "commune_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_commune_admins_on_commune_id"
    t.index ["user_id", "commune_id"], name: "index_commune_admins_on_user_id_and_commune_id", unique: true
    t.index ["user_id"], name: "index_commune_admins_on_user_id"
  end

  create_table "commune_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "commune_id"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_commune_users_on_commune_id"
    t.index ["user_id", "commune_id"], name: "index_commune_users_on_user_id_and_commune_id", unique: true
    t.index ["user_id"], name: "index_commune_users_on_user_id"
  end

  create_table "communes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "telegram_channel_token"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "commune_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_categories", force: :cascade do |t|
    t.integer "commune_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "user_id"
    t.integer "commune_id"
    t.decimal "amount"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "purchase_category_id"
    t.index ["commune_id"], name: "index_purchases_on_commune_id"
    t.index ["created_at"], name: "index_purchases_on_created_at"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.integer "to"
    t.integer "from"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commune_id"
    t.index ["commune_id", "from"], name: "index_refunds_on_commune_id_and_from"
    t.index ["commune_id", "to"], name: "index_refunds_on_commune_id_and_to"
    t.index ["commune_id"], name: "index_refunds_on_commune_id"
  end

  create_table "task_completions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_task_completions_on_created_at"
    t.index ["task_id"], name: "index_task_completions_on_task_id"
    t.index ["user_id"], name: "index_task_completions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "commune_id"
    t.string "name"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reward"
    t.string "completion_text"
    t.integer "creator_id"
    t.index ["commune_id"], name: "index_tasks_on_commune_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "email"
    t.integer "default_commune_id"
    t.string "default_theme"
  end

  create_table "xps", force: :cascade do |t|
    t.integer "points"
    t.integer "user_id"
    t.integer "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commune_id"
    t.index ["commune_id"], name: "index_xps_on_commune_id"
    t.index ["created_at"], name: "index_xps_on_created_at"
    t.index ["user_id"], name: "index_xps_on_user_id"
  end

end
