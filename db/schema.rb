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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120329094806) do

  create_table "feed_urls", :force => true do |t|
    t.string   "feed_url"
    t.string   "title"
    t.boolean  "star",       :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "site_url"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "feed_url_id"
    t.string   "title"
    t.string   "author"
    t.string   "link"
    t.string   "site_link"
    t.string   "site_title"
    t.text     "content"
    t.datetime "published"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "hidden_feeds", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feed_url_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "hidden_feeds", ["feed_url_id"], :name => "index_hidden_feeds_on_feed_url_id"
  add_index "hidden_feeds", ["user_id", "feed_url_id"], :name => "index_hidden_feeds_on_user_id_and_feed_url_id", :unique => true
  add_index "hidden_feeds", ["user_id"], :name => "index_hidden_feeds_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "secret_rss_key"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
