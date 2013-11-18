class GSubtopic < ActiveRecord::Base
  attr_accessible :topic_chs, :topic_eng, :priority, :v_count, :d_count, :g_topic_id

  has_many :d_meta_subtopicships
  has_many :d_metadatas, :through => :d_meta_subtopicships

  has_many :v_meta_subtopicships
  has_many :v_metadatas, :through => :v_meta_subtopicships

  belongs_to :g_topic
end
