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

ActiveRecord::Schema.define(version: 20210209125522) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "overtime_at"
    t.boolean "next_day"
    t.string "work_content"
    t.string "superior_confirmation"
    t.boolean "change"
    t.string "overtime_status"
    t.boolean "tomorrow"
    t.string "superior_check"
    t.boolean "modify"
    t.string "change_status"
    t.datetime "change_started_at"
    t.datetime "change_finished_at"
    t.boolean "month_modify"
    t.string "month_status"
    t.string "month_superior"
    t.date "apply_month"
    t.date "approval_day"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "attendance_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.boolean "superior", default: false
    t.integer "employee_number"
    t.integer "uid"
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2021-09-28 23:00:00"
    t.datetime "designated_work_start_time", default: "2021-09-29 00:00:00"
    t.datetime "designated_work_end_time", default: "2021-09-29 09:00:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
