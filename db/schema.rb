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

ActiveRecord::Schema.define(:version => 20131114120727) do

  create_table "d_meta_regionships", :id => false, :force => true do |t|
    t.integer  "d_metadata_id", :null => false
    t.integer  "g_region_id",   :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "d_meta_regionships", ["d_metadata_id"], :name => "fk_dmeta_reg"
  add_index "d_meta_regionships", ["g_region_id"], :name => "fk_reg_dmeta"

  create_table "d_meta_tagships", :id => false, :force => true do |t|
    t.integer  "d_metadata_id", :null => false
    t.integer  "g_tag_id",      :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "d_meta_tagships", ["d_metadata_id"], :name => "fk_dmeta_tag"
  add_index "d_meta_tagships", ["g_tag_id"], :name => "fk_tag_dmeta"

  create_table "d_meta_translatorships", :id => false, :force => true do |t|
    t.integer  "d_metadata_id",   :null => false
    t.integer  "g_translator_id", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "d_meta_translatorships", ["d_metadata_id"], :name => "fk_dmeta_trans"
  add_index "d_meta_translatorships", ["g_translator_id"], :name => "fk_trans_dmeta"

  create_table "d_metadata", :force => true do |t|
    t.string   "gsd_number",    :limit => 20,  :null => false
    t.string   "title_eng",     :limit => 50,  :null => false
    t.string   "title_chs",     :limit => 100, :null => false
    t.integer  "v_metadata_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "d_metadata", ["v_metadata_id"], :name => "fk_v_meta"

  create_table "g_regions", :force => true do |t|
    t.string   "name_chs",   :limit => 100
    t.string   "name_eng",   :limit => 25
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "g_tags", :force => true do |t|
    t.string   "tag",        :limit => 100
    t.integer  "grade",                     :default => 0
    t.integer  "v_count",                   :default => 0
    t.integer  "d_count",                   :default => 0
    t.integer  "g_topic_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "g_topics", :force => true do |t|
    t.string   "topic_chs",  :limit => 50,                :null => false
    t.string   "topic_eng",  :limit => 25,                :null => false
    t.integer  "priority",                 :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "g_translators", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "v_clarities", :force => true do |t|
    t.string   "clarity",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "v_meta_regionships", :id => false, :force => true do |t|
    t.integer  "v_metadata_id", :null => false
    t.integer  "g_region_id",   :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "v_meta_regionships", ["g_region_id"], :name => "fk_reg_vmeta"
  add_index "v_meta_regionships", ["v_metadata_id"], :name => "fk_vmeta_reg"

  create_table "v_meta_tagships", :id => false, :force => true do |t|
    t.integer  "v_metadata_id", :null => false
    t.integer  "g_tag_id",      :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "v_meta_tagships", ["g_tag_id"], :name => "fk_tag_vmeta"
  add_index "v_meta_tagships", ["v_metadata_id"], :name => "fk_vmeta_tag"

  create_table "v_meta_translatorships", :id => false, :force => true do |t|
    t.integer  "v_metadata_id",   :null => false
    t.integer  "g_translator_id", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "v_meta_translatorships", ["g_translator_id"], :name => "fk_trans_vmeta"
  add_index "v_meta_translatorships", ["v_metadata_id"], :name => "fk_vmeta_trans"

  create_table "v_metadata", :force => true do |t|
    t.string   "gsv_number",        :limit => 20,                 :null => false
    t.string   "title_eng",         :limit => 50,                 :null => false
    t.string   "title_chs",         :limit => 100,                :null => false
    t.string   "audio_language",    :limit => 20
    t.string   "subtitle_language", :limit => 20
    t.text     "description"
    t.integer  "duration",                         :default => 0
    t.date     "create_date"
    t.string   "video_path",        :limit => 100
    t.string   "img_path",          :limit => 100
    t.integer  "counter",                          :default => 0
    t.integer  "v_clarity_id"
    t.integer  "v_provider_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "v_metadata", ["v_clarity_id"], :name => "fk_v_clarity"
  add_index "v_metadata", ["v_provider_id"], :name => "fk_v_provider"

  create_table "v_providers", :force => true do |t|
    t.string   "provider",   :null => false
    t.string   "detail",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
