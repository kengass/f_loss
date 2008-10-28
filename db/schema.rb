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

ActiveRecord::Schema.define(:version => 10) do

  create_table "fldates", :force => true do |t|
    t.integer  "security_id"
    t.decimal  "cdr",         :precision => 5,  :scale => 1
    t.decimal  "severity",    :precision => 5,  :scale => 1
    t.date     "f_loss"
    t.decimal  "principal",   :precision => 15, :scale => 2
    t.decimal  "writedown",   :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "securities", :force => true do |t|
    t.string   "cusip"
    t.string   "fund"
    t.date     "date"
    t.string   "title"
    t.string   "filename"
    t.string   "moodys",                                        :default => "N/A"
    t.string   "s_p",                                           :default => "N/A"
    t.string   "fitch",                                         :default => "N/A"
    t.decimal  "ce_orig",         :precision => 8, :scale => 2
    t.decimal  "ce_cur",          :precision => 8, :scale => 2
    t.decimal  "qtr_cdr",         :precision => 8, :scale => 2
    t.decimal  "qtr_severity",    :precision => 8, :scale => 2
    t.string   "forclosure_reo"
    t.string   "delinq_30_60_90"
    t.integer  "cpr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "securities_users", :id => false, :force => true do |t|
    t.integer "security_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.boolean  "enabled",                                 :default => true
  end

  create_table "viewdates", :force => true do |t|
    t.date     "vdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
