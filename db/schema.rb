# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101021032754) do

  create_table "logs", :force => true do |t|
    t.string   "ip"
    t.string   "youtube_id"
    t.string   "timelog"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.integer  "correct_count",   :default => 0
    t.integer  "incorrect_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["user_id", "survey_id"], :name => "index_participations_on_user_id_and_survey_id"

  create_table "user_answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.boolean  "correct",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_answers", ["answer_id"], :name => "index_user_answers_on_answer_id"
  add_index "user_answers", ["question_id"], :name => "index_user_answers_on_question_id"
  add_index "user_answers", ["user_id"], :name => "index_user_answers_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "videos", :force => true do |t|
    t.string   "youtube_id"
    t.text     "heatmap"
    t.integer  "duration"
    t.integer  "user_id"
    t.float    "total_views"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
