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

ActiveRecord::Schema.define(:version => 20080712230833) do

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
    t.text     "code_blocks"
    t.string   "title",       :null => false
  end

  add_index "page_versions", ["section_id"], :name => "index_page_versions_on_section_id"

  create_table "pages", :force => true do |t|
    t.string   "path",                       :null => false
    t.text     "body"
    t.text     "rendered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parser"
    t.integer  "version",     :default => 0, :null => false
    t.integer  "section_id"
    t.text     "code_blocks"
    t.string   "title",                      :null => false
  end

  add_index "pages", ["path"], :name => "index_pages_on_path"
  add_index "pages", ["section_id"], :name => "index_pages_on_section_id"

  create_table "sections", :force => true do |t|
    t.string "name"
  end

end
