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

ActiveRecord::Schema.define(:version => 20080927224142) do

  create_table "code_blocks", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.string   "language"
    t.text     "code"
    t.text     "highlighted"
    t.string   "theme"
    t.datetime "created_at"
  end

  add_index "code_blocks", ["created_at"], :name => "index_code_blocks_on_created_at"
  add_index "code_blocks", ["language"], :name => "index_code_blocks_on_language"
  add_index "code_blocks", ["page_id"], :name => "index_code_blocks_on_page_id"
  add_index "code_blocks", ["version"], :name => "index_code_blocks_on_version"

  create_table "destinations", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.string   "path"
    t.text     "body"
    t.text     "rendered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parser"
    t.integer  "section_id"
    t.string   "title",      :null => false
  end

  add_index "page_versions", ["section_id"], :name => "index_page_versions_on_section_id"

  create_table "pages", :force => true do |t|
    t.string   "path",                      :null => false
    t.text     "body"
    t.text     "rendered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parser"
    t.integer  "version",    :default => 0, :null => false
    t.integer  "section_id"
    t.string   "title",                     :null => false
  end

  add_index "pages", ["path"], :name => "index_pages_on_path"
  add_index "pages", ["section_id"], :name => "index_pages_on_section_id"

  create_table "publishings", :force => true do |t|
    t.integer  "destination_id"
    t.integer  "page_version_id"
    t.datetime "created_at"
  end

  add_index "publishings", ["destination_id"], :name => "index_publishings_on_destination_id"
  add_index "publishings", ["page_version_id"], :name => "index_publishings_on_page_version_id"

  create_table "sections", :force => true do |t|
    t.string "name"
  end

end
