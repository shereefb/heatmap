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

ActiveRecord::Schema.define(:version => 20100317044924) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "body"
    t.boolean  "correct",     :default => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "surveys_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.integer  "correct_count",   :default => 0
    t.integer  "incorrect_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["user_id", "survey_id"], :name => "index_participations_on_user_id_and_survey_id"

  create_table "questions", :force => true do |t|
    t.integer  "survey_id"
    t.text     "body"
    t.integer  "answers_count", :default => 0
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.integer  "suggester_id"
    t.boolean  "approved",      :default => false
  end

  add_index "questions", ["approved"], :name => "index_questions_on_approved"
  add_index "questions", ["survey_id"], :name => "index_questions_on_survey_id"
  add_index "questions", ["suggester_id"], :name => "index_questions_on_suggester_id"

  create_table "surveys", :force => true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.integer  "questions_count",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.integer  "participations_count", :default => 0
    t.datetime "questions_updated_at"
    t.datetime "last_viewed"
  end

  add_index "surveys", ["category_id"], :name => "index_surveys_on_category_id"
  add_index "surveys", ["last_viewed"], :name => "index_surveys_on_last_viewed"
  add_index "surveys", ["permalink"], :name => "index_surveys_on_permalink"
  add_index "surveys", ["questions_updated_at"], :name => "index_surveys_on_questions_updated_at"
  add_index "surveys", ["user_id"], :name => "index_surveys_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

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

end
